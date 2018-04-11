class Pledges::DonorStatusesController < ApplicationController

  def update
    @pledge = Pledge.find(params[:pledge_id])
    authorize @pledge, :donor_status_update?

    @pledge.donor_transferred!

    flash[:success] = 'Thank you!'
    redirect_back(fallback_location: @pledge.request)
  end
end