class Pledges::RequesterStatusesController < ApplicationController

  def update
    @pledge = Pledge.find(params[:pledge_id])
    authorize @pledge, :requester_status_update?
    
    if params[:requester_status] == "requester_received"
      @pledge.requester_received!
    elsif params[:requester_status] == "expired"
      @pledge.expired!
    else
      raise "Status received #{params[:requester_status]}"
    end

    flash[:success] = 'Pledge has been updated'
    redirect_to(request_manage_pledges_path @pledge.request)
  end
end