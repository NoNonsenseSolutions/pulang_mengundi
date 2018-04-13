class Pledges::DisputesController < ApplicationController
  def create
    @pledge = Pledge.find(params[:pledge_id])
    authorize @pledge, :requester_status_update?

    @dispute = @pledge.disputes.new(dispute_params)

    if @dispute.save
      @pledge.requester_disputed!
      flash[:success] = 'Disputed'
    else
      flash[:danger] = @dispute.errors.full_messages.join('; ')
    end
    redirect_back(fallback_location: root_path)
  end

  private
    def dispute_params
      params.require(:dispute).permit(:comment)
    end
end