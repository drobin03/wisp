class RankingController < ApplicationController
  respond_to :html, :js
  
  def city_ranked_isp_list
    name = params["city"].nil? ? "Guelph" : params["city"]
    city = City.find_by(name: name.downcase)
    
    # return_val = Hash.new
    # return_val[:isps] = city.isps.to_json
    # return_val[:message] = "your list!"
    # render json: return_val
    @isp_list = city.isps
  end

end