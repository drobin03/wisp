class Province < ActiveRecord::Base
  belongs_to :country
  has_many :cities, dependent: :destroy

  validates :country, :name, presence: true
end
