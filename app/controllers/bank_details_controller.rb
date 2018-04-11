class BankDetailsController < ApplicationController
  before_action :find_request
  before_action :authorize_donor_only!
  def show
    @pledges = Pledge.where(request: @request, donor: current_user)
  end

  private
    def find_request
      @request = Request.find(params[:request_id])
    end

    def authorize_donor_only!
      unless @request.pledges.pluck(:donor_id).include?(current_user.id)
        flash[:danger] = 'Unauthorized'
        redirect_to root_path
      end
    end
end