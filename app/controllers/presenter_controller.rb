class PresenterController < ApplicationController

  def show_home_page
    @countries = Country.all
  end
end
