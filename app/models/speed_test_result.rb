class SpeedTestResult < ActiveRecord::Base
  belongs_to :city
  belongs_to :isp_company

  validates :city, :isp_company, :download_kbps, :upload_kbps, :date, :total_tests, :distance_miles, presence: true
  # To prevent duplicate entries.
  validates :date, uniqueness: {scope: [:city, :isp_company, :download_kbps, :upload_kbps]}
end
