class Country < ActiveRecord::Base
  has_many :provinces, dependent: :destroy
  has_many :cities, through: :provinces
  has_many :isps, through: :cities
  has_many :isp_companies, through: :isps
  
  validates :name, :longitude, :latitude, presence: true
    
  def isp_ranked_list
    # sort by (avg download speed measured / cable price)
    results = SpeedTestResult.select("speed_test_results.isp_company_id, MIN(isps.cable_price) AS cable_price, AVG(speed_test_results.download_kbps) AS avg_download_kbps, AVG(speed_test_results.download_kbps)/MIN(isps.cable_price) AS download_per_dollar").
                joins("JOIN isps ON isps.isp_company_id = speed_test_results.isp_company_id AND isps.city_id = speed_test_results.city_id").
                where("isps.cable_price > 0").
                group(:isp_company_id).
                order("download_per_dollar DESC").
                joins(:isp_company)
  end
end
