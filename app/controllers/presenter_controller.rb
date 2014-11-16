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
    @isp_company_options = IspCompany.all
    @isp_company_selected = IspCompany.find(params[:isp_company_id]) unless params[:isp_company_id].nil? || params[:isp_company_id].empty?

    if params[:province_id].empty?
      @city_options = City.all
    else
      @city_options = Province.find(params[:province_id]).cities
      @province_selected = Province.find(params[:province_id])
    end

    if !params[:city_id].empty?
      @city_selected = City.find(params[:city_id])
      # Check if city selected is actually within the province
      if !@city_options.include? @city_selected
        @city_selected = nil
      else
        @isp_company_options = @city_selected.isp_companies
        @province_selected = @city_selected.province
      end
    end
  end
end
