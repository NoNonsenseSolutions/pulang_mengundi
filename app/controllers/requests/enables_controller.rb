class Requests::EnablesController < ApplicationController
  def create
    @request = Request.find(params[:request_id])
    authorize(@request, :destroy?)
    if @request.disabled?
      @request.enable!
      flash[:success] = t(".enabled")
    else
      flash[:danger] = t('.not_disabled')
    end
    redirect_back(fallback_location: manage_pledge_path(@request))
  end
end