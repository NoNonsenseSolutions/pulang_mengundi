class PledgesController < ApplicationController
  def create
    @request = Request.find(params[:request_id])
    @pledge = @request.pledges.new(pledge_params.merge(donor: current_user))
    if @pledge.save
      flash[:success] = 'Pledged'
      redirect_to [@request, :bank_details]
    else
      flash[:danger] = @pledge.errors.full_messages.join("; ")
      @request.reload
      @referred = @request.referrer
      render '/requests/show'
    end
  end

  private
    def pledge_params
      params.require(:pledge).permit(:amount)
    end
end