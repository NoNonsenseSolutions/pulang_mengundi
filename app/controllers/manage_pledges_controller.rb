# frozen_string_literal: true

class ManagePledgesController < ApplicationController
  def index
    @request = Request.find(params[:request_id])
    authorize @request, :manage?
    @pledges = @request.pledges
  end

  def show
    @pledge = Pledge.find(params[:id])
    authorize @pledge, :requester_status_update?
    @request = @pledge.request
    @presenter = PledgePresenter.new(@pledge)
  end
end
