class RankingController < ApplicationController
  respond_to :html, :js
  
  def city_ranked_isp_list
    name = params["city"].nil? ? "Guelph" : params["city"]
    city = City.find_by(name: name.downcase)
    
    # return_val = Hash.new
    # return_val[:isps] = city.isps.to_json
    # return_val[:message] = "your list!"
    # render json: return_val
    @isp_list = city.isp_ranked_list.map(&:isp_company)
    @ranking_list_name = "City Ranking"
  end
  
  def country_ranked_isp_list
    name = params["country"].nil? ? "Canada" : params["country"]
    country = Country.find_by(name: name.downcase)

    @isp_list = country.isp_ranked_list
    @ranking_list_name = "Country Ranking"
  end

  def cities
    render json: City.all
  end

end