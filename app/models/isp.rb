class Isp < ActiveRecord::Base
  belongs_to :city
  has_one :isp_company

  validates :city, :isp_company, :download_kbps, :upload_kbps, presence: true
end
