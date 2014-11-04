class Conversation < ActiveRecord::Base
  belongs_to :isp

  validates :user_name, :isp, :feedback, presence: true
end
