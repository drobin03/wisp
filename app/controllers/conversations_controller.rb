class ConversationsController < ApplicationController
  respond_to :html, :js
  
  
  def index
    @conversations = Conversation.all
  end

  def show
    @conversation = Conversation.find(params[:id])
  end

  def new
    @conversation = Conversation.new
  end

  def create
    @conversation = Conversation.new(conversation_params)
    if @conversation.save
      redirect_to conversations_dashboard_path
    else
      render :action => 'new'
    end
  end

  private
    def conversation_params
      params.require(:conversation).permit(
        :user_name, :province_id, :city_id, :isp_company_id, :subject, :body)
    end
end
