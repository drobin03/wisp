class Conversation < ActiveRecord::Base
  belongs_to :isp

  validates :user_name, :isp, :body, presence: true

  def date
  	self.created_at.strftime("%d/%m/%Y %I:%M%p")
  end

  def breadcrumbs
  	#self.province + "/" + self.city + "/" 
  	self.isp.isp_company.name
  end
  validates :user_name, :isp, :subject, :body, presence: true
end
