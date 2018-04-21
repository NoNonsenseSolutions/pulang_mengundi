# frozen_string_literal: true

class Pledges::UploadReceiptsController < ApplicationController
  def create
    @pledge = Pledge.find(params[:pledge_id])
    authorize @pledge, :donor_status_update?

    if params.dig(:pledge, :receipt)
      @pledge.receipt.attach(receipt_params[:receipt])
      @pledge.donor_transferred!
      @pledge.confirmed_at = Time.zone.now
      @pledge.save

      flash[:success] = t('.thank_you')
      redirect_to for_pledging_thank_you_screens_path
    else
      flash[:danger] = t('.missing_receipt')
      redirect_back(fallback_location: @pledge)
    end
  end

  private

  def receipt_params
    params.require(:pledge).permit(:receipt)
  end
end
