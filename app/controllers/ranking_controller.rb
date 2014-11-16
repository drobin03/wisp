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
    cities = City.select("name, rank, longitude, latitude, AVG(speed_test_results.download_kbps) as avg_download").joins(:speed_test_results).group("cities.id").to_json
    render json: cities
  end

end