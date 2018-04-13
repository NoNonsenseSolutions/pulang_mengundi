class Pledges::UploadReceiptsController < ApplicationController
  def create
    @pledge = Pledge.find(params[:pledge_id])
    @pledge.receipt.attach(receipt_params[:receipt])
    flash[:success] = 'Attached'
    redirect_back(fallback_location: @pledge)
  end

  private
    def receipt_params
      params.require(:pledge).permit(:receipt)
    end
end