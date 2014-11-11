class CityController < ApplicationController
  def update
    city = City.find_by(name: params[:city_name])
    city.longitude = params[:longitude].to_f
    city.latitude = params[:latitude].to_f
    if city.save?
      respond_with json: city
    end
  end
end
