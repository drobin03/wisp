class Conversation < ActiveRecord::Base
  belongs_to :city
  belongs_to :isp
end
