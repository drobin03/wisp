class Country < ActiveRecord::Base
  has_many :provinces, dependent: :destroy
  has_many :cities, through: :provinces
  has_many :isps, through: :cities
  has_many :isp_companies, through: :isps
  
  validates :name, :longitude, :latitude, presence: true
    
  def isp_ranked_list
    self.isp_companies.uniq
  end
end
