class Isp < ActiveRecord::Base
  belongs_to :city
  belongs_to :isp_company

  validates :city, :isp_company, presence: true
  validates :isp_company, uniqueness: {scope: :city}
end
