class Requests::DisablesController < ApplicationController
  def create
    @request = Request.find(params[:request_id])
    authorize(@request, :destroy?)
    if @request.disabled?
      flash[:danger] = t('.already_disabled')
    else
      @request.disable!
      flash[:success] = t('.disabled')
    end
    redirect_back(fallback_location: manage_pledge_path(@request))
  end
end