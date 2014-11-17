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

  def update
    @AllConversations = Conversation.order("created_at DESC")
    @Conversations = Array.new
    @AllConversations.each do |conversation|
      if params[:province_id].empty? or params[:province_id].to_i == conversation.province_id
        if params[:city_id].empty? or params[:city_id].to_i == conversation.city_id
          if params[:isp_company_id].empty? or params[:isp_company_id].to_i == conversation.isp_company_id
            @Conversations.push(conversation)
          end
        end
      end
    end
  end

private

  def conversation_params
    params.require(:conversation).permit(
      :user_name, :province_id, :city_id, :isp_company_id, :subject, :body)
  end
end
