class Requests::DisablesController < ApplicationController
  def create
    @request = Request.find(params[:request_id])
    
    if @request.disabled?
      flash[:danger] = "Request already disabled"
    else
      @request.disable!
      flash[:success] = "Request disabled"
    end
    redirect_back(fallback_location: manage_pledge_path(@request))
  end
end