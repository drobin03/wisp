class City < ActiveRecord::Base
  belongs_to :province
  has_many :isps, dependent: :destroy
  has_many :speed_test_results

  validates :province, :name, presence: true
end
