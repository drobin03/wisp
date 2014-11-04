class RankingController < ApplicationController
  respond_to :html, :js
  def city_ranked_isp_list
    render json: "your list!"
  end

end