class PresenterController < ApplicationController

  def home_page
    @countries = Country.all
  end

  def rankings_page
  end
  
  def conversations_page
  end

end
