class City < ActiveRecord::Base
  belongs_to :province
  has_many :isps, dependent: :destroy

  validates :province, :name, :longitude, :latitude, presence: true
end
