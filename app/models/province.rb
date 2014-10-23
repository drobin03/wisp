class Province < ActiveRecord::Base
  belongs_to :country
  has_many :cities, dependent: :destroy

  validates :country, :name, :longitude, :latitude, presence: true
end
