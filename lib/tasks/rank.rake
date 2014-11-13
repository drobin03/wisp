namespace :rank do
  desc "Populate the rankings in the database"
  task cities: :environment do
    cities = City.all
    cities.sort_by{ |city| city.avg_download_kbps }.reverse!
    
    City.transaction do
      cities.each_with_index do |city, index|
        city.rank = index + 1
        city.save!
      end
    end

  end
end