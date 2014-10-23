class Country < ActiveRecord::Base
  has_many :provinces, dependent: :destroy
  
end
