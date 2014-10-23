class PresenterController < ApplicationController

  def home_page
    @countries = Country.all
  end
end
