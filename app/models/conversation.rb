class Conversation < ActiveRecord::Base
  belongs_to :isp

  validates :user_name, :isp, :body, presence: true
end
