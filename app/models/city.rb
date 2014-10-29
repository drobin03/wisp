class City < ActiveRecord::Base
  belongs_to :province
  has_many :isps, dependent: :destroy
  has_many :speed_test_results, dependent: :destroy
  has_many :isp_companies, through: :isps

  validates :province, :name, presence: true

  def isp_ranking_list(max_results=10)
    # Base the ranking purely on download speed for now
    self.speed_test_results.order('download_kbps DESC').take(max_results)
  end

end
