class Isp < ActiveRecord::Base
  belongs_to :city
  belongs_to :isp_company

  has_many :conversations, dependent: :destroy
  validates :city, :isp_company, presence: true
  validates :isp_company, uniqueness: {scope: :city}

  def speed_test_results
    SpeedTestResult.where(city: self.city, isp_company: self.isp_company)
  end

  def max_download_kbps
    speed_test_results.maximum(:download_kbps)
  end

  def avg_download_kbps
    speed_test_results.average(:download_kbps)
  end
end