class IspCompany < ActiveRecord::Base
  has_many :speed_test_results
  validates :name, presence: true

  def speed_test_results_for_city(city)
    debugger
  end
end
