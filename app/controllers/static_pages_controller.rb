class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:faq, :contact]
  def home
    @requests = Request.all.order(created_at: :asc)
    @total_number_of_requests = Request.count
    @total_amount_pledged = Pledge.requester_received.sum(:amount)
  end

  def faq
  end

  def contact
  end
end