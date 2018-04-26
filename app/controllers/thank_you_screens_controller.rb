# frozen_string_literal: true

class ThankYouScreensController < ApplicationController
  def show
    @request = Request.find(params[:request_id])
  end

  def for_pledging
    authorize :pledge, :sponsor_rewards?
  end
end
