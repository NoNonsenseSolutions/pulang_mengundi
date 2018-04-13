class Pledges::UploadReceiptsController < ApplicationController
  def create
    @pledge = Pledge.find(params[:pledge_id])
    authorize @pledge, :donor_status_update?

    @pledge.receipt.attach(receipt_params[:receipt])
    @pledge.donor_transferred!
    
    flash[:success] = 'Thank you!'
    redirect_to for_pledging_thank_you_screens_path
  end

  private
    def receipt_params
      params.require(:pledge).permit(:receipt)
    end
end