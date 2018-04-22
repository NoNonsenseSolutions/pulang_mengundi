# frozen_string_literal: true

class PledgesController < ApplicationController
  def index
    @pledges = policy_scope(Pledge)
  end

  def new
    @request = Request.find(params[:request_id])
    @user = current_user
    unless @user.read_terms?
      store_location
      redirect_to(terms_and_conditions_path) && return
    end

    @pledge = @request.pledges.new
    authorize @pledge
  end

  def create
    @request = Request.find(params[:request_id])
    @pledge = @request.pledges.new(pledge_params.merge(donor: current_user))
    authorize @pledge
    if verify_recaptcha(model: @pledge) && @pledge.save
      flash[:success] = t('.success')
      redirect_to @pledge
    else
      flash[:danger] = @pledge.errors.full_messages.join('; ')
      redirect_to new_request_pledge_path(@request)
    end
  end

  def show
    @pledge = Pledge.find(params[:id])
    authorize @pledge
    @request = @pledge.request
  end

  private

  def pledge_params
    params.require(:pledge).permit(:amount)
  end
end
