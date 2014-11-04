class ConversationsController < ApplicationController
  respond_to :html, :js
  def new
    @conversation = Conversation.new
  end

  def create
    @conversation = Conversation.new(conversation_params)
    if @conversation.save
      redirect_to :action => 'show'
    else
      render :action => 'new'
  end

  def index
    @conversations = Conversation.all
  end
  
  def show
    @conversation = Conversation.find(params[:id])
  end
  
  private
    def conversation_params
      params.require(:conversation).permit(
        :user_name, :feedback, :isp )
    end
end
