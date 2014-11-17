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
      redirect_to conversations_path
    else
      @Conversations = Conversation.order("created_at DESC")
    end
  end

private
  def update
    @AllConversations = Conversation.order("created_at DESC")
    @Conversation = Conversation.new
    @AllConversations.each do |conversation|
      if params[:province_id].empty or params[:province_id] == @conversation.province_id?
        if params[:city_id].empty or params[:city_id] == @conversation.city_id?
          if params[:isp_company_id].empty or params[:isp_company_id] == @conversation.isp_company_id?
            @Conversations.add(@conversation)
          end
        end
      end
    end
  end

  def conversation_params
    params.require(:conversation).permit(
      :user_name, :province_id, :city_id, :isp_company_id, :subject, :body)
  end
end
