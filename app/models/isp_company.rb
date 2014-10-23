class IspCompany < ActiveRecord::Base
  validates :name, presence: true
end
