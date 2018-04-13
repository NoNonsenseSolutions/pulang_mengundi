class CompletedRequestsController < ApplicationController
  def index
    @requests = Request.where("target_amount = total_received").without_disabled.order(created_at: :asc)
    @total_number_of_requests = @requests.count
    @total_amount_pledged = Pledge.requester_received.sum(:amount)
  end
end