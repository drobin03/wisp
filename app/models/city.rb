class City < ActiveRecord::Base
  belongs_to :province

  validates :province, :name, :longitude, :latitude, presence: true
end
