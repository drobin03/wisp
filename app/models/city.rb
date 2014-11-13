class City < ActiveRecord::Base
  belongs_to :province
  has_many :isps, dependent: :destroy
  has_many :speed_test_results, dependent: :destroy
  has_many :isp_companies, through: :isps
  has_many :conversations, through: :isps, dependent: :destroy

  validates :province, :name, presence: true

  def isp_ranked_list(max_results=100)
    valid_isps = self.isps.where('cable_price > 0')
    # sort by (max download speed measured / cable price)
    valid_isps.sort_by{ |isp| isp.avg_download_kbps.nil? ? -1 : isp.avg_download_kbps/isp.cable_price }.reverse
    # self.speed_test_results.order('download_kbps DESC').take(max_results)
  end

  def avg_download_kbps
    self.speed_test_results.average(:download_kbps)
  end

end
