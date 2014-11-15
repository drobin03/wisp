class City < ActiveRecord::Base
  belongs_to :province
  has_many :isps, dependent: :destroy
  has_many :speed_test_results, dependent: :destroy
  has_many :isp_companies, through: :isps
  has_many :conversations, through: :isps, dependent: :destroy

  validates :province, :name, presence: true

  def isp_ranked_list(max_results=100)
    self.isps.select("*, AVG(speed_test_results.download_kbps) as avg_download, AVG(speed_test_results.download_kbps) / isps.cable_price as download_per_dollar").
      where("cable_price > 0").
      joins("JOIN speed_test_results ON isps.city_id = speed_test_results.city_id and isps.isp_company_id = speed_test_results.isp_company_id").
      group("isps.city_id, isps.isp_company_id").
      having("avg_download > 0").
      order("download_per_dollar DESC")
    # sort by (max download speed measured / cable price)
    # valid_isps.sort_by{ |isp| isp.avg_download_kbps.nil? ? -1 : isp.avg_download_kbps/isp.cable_price }.reverse
    # self.speed_test_results.order('download_kbps DESC').take(max_results)
  end

  def avg_download_kbps
    self.speed_test_results.average(:download_kbps)
  end

end
