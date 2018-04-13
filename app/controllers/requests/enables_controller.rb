class Requests::EnablesController < ApplicationController
  def create
    @request = Request.find(params[:request_id])
    authorize(@request, :destroy?)
    if @request.disabled?
      @request.enable!
      flash[:success] = "Request enabled"
    else
      flash[:danger] = "Request was not disabled"
    end
    redirect_back(fallback_location: manage_pledge_path(@request))
  end
end