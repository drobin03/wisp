require 'mechanize' 
namespace :ispinfo do
  desc "Get the most recent ISP data from canadianisp.ca and import it into our database"
  task collect_data: :environment do
    mechanize = Mechanize.new

    page = mechanize.get('http://canadianisp.ca/cgi-bin/ispsearch.cgi')

    province_form = page.forms.first
    # For each province
    province = "ON"
    province_form.field_with(name: "p").value = province

    second_page = province_form.submit
    city_form = second_page.forms.third
    # For each city
    city = City.find_by(name: "Guelph")
    city_form.field_with(name: "city1").value = city.name
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
        isp = IspCompany.where(['name LIKE ?', "%#{name}%"]).first
        if isp.nil?
          puts "Isp not found - <#{data_tds[0]}>"
        else
          # TODO: Parse out speed(download, upload) somehow
          isps.push({ city: city, isp_company: isp, cable_price: data_tds[1] })
        end
      end
    end
    Isp.create(isps)

  end
end