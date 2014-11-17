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

  def isp_list
    city = City.find(params[:id])
    oldestDate = Time.now - 1.year

    top_isps = city.speed_test_results.select("isp_company_id, AVG(download_kbps) as avg_download").
      where("date > \"#{oldestDate}\"").
      group("isp_company_id").
      order("avg_download DESC").
      limit(10).
      map(&:isp_company_id)
    
    isps = city.speed_test_results.select("isp_company_id, isp_companies.name, date, AVG(download_kbps) as avg_download").
      joins(:isp_company).
      where("date > \"#{oldestDate}\"").where(isp_company_id: top_isps).
      group("isp_company_id, YEAR(date), MONTH(date)").to_json
    render json: isps
  end
end
