class RecommendationsController < ApplicationController
  respond_to :html, :js
  
  def recommend
    recommendation_params = params[:recommendation]
    city = City.find(recommendation_params[:city_id])
    isps = city.isps

    # Select the isp with the highest download/cost
    # sort by (max download speed measured / cable price)
    isps = isps.select("isps.*, MIN(isps.cable_price) AS cable_price, AVG(speed_test_results.download_kbps) AS avg_download, AVG(speed_test_results.upload_kbps) AS avg_upload, AVG(speed_test_results.download_kbps)/MIN(isps.cable_price) AS download_per_dollar").
                joins("JOIN speed_test_results ON isps.isp_company_id = speed_test_results.isp_company_id AND isps.city_id = speed_test_results.city_id").
                where("isps.cable_price > 0").
                group(:isp_company_id).
                order("download_per_dollar DESC").
                joins(:isp_company)

    min_download = params[:recommendation][:download_mbps]
    min_upload = params[:recommendation][:upload_mbps]
    max_cost = params[:recommendation][:cost]
    
    isps = isps.find_all{ |isp| isp.avg_download / 1000 > min_download.to_f } unless min_download.empty?
    isps = isps.find_all{ |isp| isp.avg_upload / 1000 > min_upload.to_f } unless min_upload.empty?
    isps = isps.find_all{ |isp| isp.cable_price <= max_cost.to_f } unless max_cost.empty?
    @isp = isps.first
    # valid_isps.sort_by{ |isp| isp.avg_download_kbps.nil? ? -1 : isp.avg_download_kbps/isp.cable_price }.last
  end

end