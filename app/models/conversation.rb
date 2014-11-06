class Conversation < ActiveRecord::Base
  belongs_to :isp

  validates :user_name, :isp, :subject, :body, presence: true
  validates :city, presence: true, if => "!province.empty?"
end
