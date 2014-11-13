class CityController < ApplicationController
  respond_to :js

  def update
    city = City.find_by(name: params[:city_name])
    if !city.nil?
      city.longitude = params[:longitude].to_f
      city.latitude = params[:latitude].to_f
      if city.save
        render json: city
      end
    else
      render json: { error: "No city with that name " + params[:city_name] }
    end
  end
end
