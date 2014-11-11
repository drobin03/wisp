class Conversation < ActiveRecord::Base
  belongs_to :isp_company
  belongs_to :city
  belongs_to :province

  def date
  	self.created_at.strftime("%d/%m/%Y %I:%M%p")
  end

  def breadcrumbs
  	self.province.name + " / " + self.city.name + " / " + self.isp_company.name
  end

  validates :user_name, :province, :city, :isp_company, :subject, :body, presence: true
end
