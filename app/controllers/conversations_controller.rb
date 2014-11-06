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
      redirect_to :action => 'show'
    else
      render :action => 'new'
    end
  end

  private
    def conversation_params
      params.require(:conversation).permit(
        :user_name, :province, :city, :isp, :subject, :body)
    end
end
