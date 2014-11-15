class RankingController < ApplicationController
  respond_to :html, :js
  
  def city_ranked_isp_list
    name = params["city"].nil? ? "Guelph" : params["city"]
    city = City.find_by(name: name.downcase)
    
    # return_val = Hash.new
    # return_val[:isps] = city.isps.to_json
    # return_val[:message] = "your list!"
    # render json: return_val
    @isp_list = city.isp_ranked_list
    @ranking_list_name = "Top ISPs in your City"
  end
  
  def country_ranked_isp_list
    name = params["country"].nil? ? "Canada" : params["country"]
    country = Country.find_by(name: name.downcase)

    @isp_list = country.isp_ranked_list
    @ranking_list_name = "Top ISPs in Canada"
  end

  def cities
    cities = City.all.to_json(only: [:name, :rank, :longitude, :latitude], methods: [:avg_download_kbps])
    render json: cities
  end

end