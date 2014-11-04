class RankingController < ApplicationController
  respond_to :html, :js
  def city_ranked_isp_list
    return_val = Hash.new
    return_val[:message] = "your list!"
    render json: return_val
  end

end