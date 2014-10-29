require 'mechanize' 
namespace :ispinfo do
  desc "Get the most recent ISP data from canadianisp.ca and import it into our database"
  task collect_data: :environment do
    mechanize = Mechanize.new

    page = mechanize.get('http://canadianisp.ca/cgi-bin/ispsearch.cgi')

    province_form = page.forms.first
    country = Country.find_by(name: "Canada")
    country.provinces.each do |province|
      province_options = province_form.field_with(name: "p").options.select { |option| option.text.downcase.include? province.name.downcase }
      province_code = province_options.empty? ? nil : province_options.first.value
      if province_code.nil?
        puts "Invalid province #{province.name}"
        next
      end
      province_form.field_with(name: "p").value = province_code

      second_page = province_form.submit
      city_form = second_page.forms.third

      province.cities.each do |city|
        # For each city
        city_options = city_form.field_with(name: "city1").options.select { |option| option.value.downcase.include? city.name.downcase }
        city_value = city_options.empty? ?  nil : city_options.first.value
        if city_value.nil?
          puts "Invalid city #{city.name}"
          next
        end
        city_form.field_with(name: "city1").value = city_value
        city_form.field_with(name: "service").value = "cable" # only retrieving cable data for now
        
        results_page = city_form.submit
        results_table = results_page.search("table table").first
        isps = Array.new
        results_table.search("tr").each do |tr|
          data_tds = tr.search("td").map do |td|
            tags = td.search("b")
            if tags.length > 0 
              text = tags.first.text
            else 
              text = td.text
            end
            text.gsub(/\302\240|\s/, ' ').strip
          end
          # Search for the isp in our database
          if !data_tds.empty? && !data_tds[0].empty?
            name = data_tds[0].split(" ")[0]
            isp_company = IspCompany.where(['name LIKE ?', "%#{name}%"]).first
            if isp_company.nil?
              puts "Isp not found - <#{data_tds[0]}>"
            else
              speed_data = parse_speeds(data_tds[2])
              cable_price = data_tds[1].gsub(/\$/, '').to_f

              params = { city: city, isp_company: isp_company, cable_price: cable_price }
              if !speed_data.empty?
                params[:download_kbps] = speed_data[:download_kbps] 
                params[:upload_kbps] = speed_data[:upload_kbps]
              end

              isp = city.isps.select {|city_isp| city_isp.isp_company_id.eql? isp_company.id }.first
              if isp
                # ISP already exists, update it's data
                if !speed_data.empty?
                  isp.download_kbps = speed_data[:download_kbps]
                  isp.upload_kbps = speed_data[:upload_kbps]
                end
                isp.cable_price = cable_price
                isp.save
              else
                isps.push(Isp.new(params))
              end

            end
          end
        end
        import = Isp.import isps, on_duplicate_key_update: [ :download_kbps, :upload_kbps, :cable_price ]
      end
    end
  end

  def parse_speeds(speed_data_text)
    speed_data = Hash.new
    if match = speed_data_text.match(/([0-9]+) *[Mm].*?([0-9]+) *[Mm]/i)
      speed_data[:download_kbps], speed_data[:upload_kbps] = match.captures
      speed_data[:download_kbps] = convert_mb_to_kb(speed_data[:download_kbps].to_i)
      speed_data[:upload_kbps] = convert_mb_to_kb(speed_data[:upload_kbps].to_i)
    end
    speed_data
  end

  def convert_mb_to_kb(data_in_mb)
    data_in_kb = data_in_mb * 1000
  end
end