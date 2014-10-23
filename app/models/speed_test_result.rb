class SpeedTestResult < ActiveRecord::Base
  belongs_to :city
  has_one :isp_company

  validates :city, :isp_company, :download_kbps, :upload_kbps, :date, :total_tests, :distance_miles, presence: true
end
