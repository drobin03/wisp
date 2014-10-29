require 'csv' 
require 'byebug' 
namespace :speedtest do
  desc "Get the most recent data from speedtest http://www.netindex.com/ and import it into our database"
  task split_canadian_data: :environment do
    filename = "#{Rails.root}/tmp/speedtest_data/city_isp_daily_speeds.csv"
    canadian_file = "#{Rails.root}/tmp/speedtest_data/canada.csv"
    CSV.open(canadian_file, "wb",
      :write_headers=> true,
      :headers => ["country","province","city","isp_name","date","download_kbps","upload_kbps","total_tests","distance_miles"]) do |out|
      n = SmarterCSV.process(filename, {:chunk_size => 100, :file_encoding => 'ISO-8859-15', 
          :key_mapping => { 
            :country => :country,
            :region => :province,
            :city => :city,
            :date => :date,
            :isp_name => :isp_name,
            :download_kbps => :download_kbps,
            :upload_kbps => :upload_kbps,
            :total_tests => :total_tests,
            :distance_miles => :distance_miles }, :remove_unmapped_keys => true }) do |chunk|

        chunk.each do |row| 
          if row[:country].downcase.eql? "canada"
            out << row.values
          end
        end
      end
    end
  end

  task collect_data: :environment do   

    # Retrieve new file from netindex
    # unzip file
    # replace old file
    countries = Country.all
    provinces = Province.all
    cities = City.all
    canada = Country.find_by(name: "Canada")
    isps = IspCompany.all


    num_rows = 0
    total_processed = 0
    start_time = Time.now
    canadian_file = "#{Rails.root}/tmp/speedtest_data/canada.csv"

    n = SmarterCSV.process(canadian_file, {:chunk_size => 100000, :file_encoding => 'utf-8', 
        :key_mapping => { 
          :country => :country,
          :region => :province,
          :city => :city,
          :date => :date,
          :download_kbps => :download_kbps,
          :upload_kbps => :upload_kbps,
          :total_tests => :total_tests,
          :distance_miles => :distance_miles }, :remove_unmapped_keys => false }) do |chunk|

        total_processed += 100000

        results_to_store = Array.new
        # Just Canada for now
        chunk.each do |row|
          province_name = I18n.transliterate row[:province]
          city_name = I18n.transliterate row[:city]
          if row[:country].downcase.eql? "canada"
            # Create Provinces
            if !provinces.map(&:name).include? province_name
              new_province = Province.create(country: canada, name: province_name)
              provinces.push(new_province)
            end

            # Create Cities
            if !cities.map(&:name).include? city_name
              puts "Creating a new city #{city_name}"
              new_city = City.create(province: Province.find_by(name: province_name), name: city_name) 
              cities.push(new_city)
            end

            # Create ISP Companies
            if !isps.map(&:name).include? row[:isp_name]
              new_isp = IspCompany.create(name: row[:isp_name]) 
              isps.push(new_isp)
            end
            city = cities.select {|city| city[:name].eql?("#{city_name}")}.first
            isp_company = isps.select {|isp| isp[:name].eql?("#{row[:isp_name]}")}.first
            results_to_store.push (SpeedTestResult.new({ city: city, isp_company: isp_company, date: row[:date],  download_kbps: row[:download_kbps], upload_kbps: row[:upload_kbps], total_tests: row[:total_tests], distance_miles: row[:distance_miles] }))
          end
        end
        # NOW - store results chunk (faster in batches)
        if results_to_store.length > 0
          puts "Storing entries, total processed - #{total_processed}"
          puts "Time elapsed - #{Time.now - start_time}"
          import = SpeedTestResult.import results_to_store, on_duplicate_key_update: [ :download_kbps, :upload_kbps, :total_tests, :distance_miles ], validate: false
        end
      end
    end
end
