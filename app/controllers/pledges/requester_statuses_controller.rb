class Pledges::RequesterStatusesController < ApplicationController

  def update
    @pledge = Pledge.find(params[:pledge_id])
    authorize @pledge, :requester_status_update?

    if params[:requester_status] == "requester_disputed"
      @pledge.requester_disputed!
    elsif params[:requester_status] == "requester_received"
      @pledge.requester_received!
      if @pledge.pending_donor?
        @pledge.donor_transferred!
      end
    else
      raise "Status received #{params[:requester_status]}"
    end

    flash[:success] = 'Pledge has been updated'
    redirect_back(fallback_location: @pledge.request)
  end
end