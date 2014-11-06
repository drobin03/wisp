class Conversation < ActiveRecord::Base
  belongs_to :isp

<<<<<<< HEAD
  validates :user_name, :isp, :body, presence: true

  def date
  	self.created_at.strftime("%d/%m/%Y %I:%M%p")
  end

  def breadcrumbs
  	#self.province + "/" + self.city + "/" self.isp
  	self.isp
  end
=======
  validates :user_name, :isp, :subject, :body, presence: true
  validates :city, presence: true, if => "!province.empty?"
>>>>>>> 8196524895cef3f6a137d2303eb7a72d21dbe56b
end
