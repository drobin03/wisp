class PresenterController < ApplicationController

  def home_page
    @countries = Country.all
  end

  def rankings_page
  end
  
  def conversations_page
    @conversation = Conversation.new unless @conversation
  	@Conversations = Conversation.order("created_at DESC")
  end

  def filter_location
      @city_options = Province.find(params[:province_id]).cities unless params[:province_id].nil?
  end
end
