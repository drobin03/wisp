class RecommendationsController < ApplicationController
  respond_to :html, :js
  
  def recommend
    recommendation_params = params[:recommendation]
    city = City.find(recommendation_params[:city_id])
    isps = city.isps

    # Select the isp with the highest download/cost
    # Filter results by params
    valid_isps = isps.where('cable_price > 0')
    # sort by (max download speed measured / cable price)
    @isp = valid_isps.sort_by{ |isp| isp.max_download_kbps.nil? ? -1 : isp.max_download_kbps/isp.cable_price }.last
  end

end