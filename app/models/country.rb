class Country < ActiveRecord::Base
  has_many :provinces, dependent: :destroy

  validates :name, :longitude, :latitude, presence: true

end
