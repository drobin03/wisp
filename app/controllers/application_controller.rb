class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  after_filter :clear_xhr_flash


  def clear_xhr_flash
    if request.xhr?
      # Also modify 'flash' to other attributes which you use in your common/flashes for js
      flash.discard
    end
  end 
end
