class PledgesController < ApplicationController

  def index
    
  end

  def new
    @request = Request.find(params[:request_id])
    @pledge = @request.pledges.new
  end

  def create
    @request = Request.find(params[:request_id])
    @pledge = @request.pledges.new(pledge_params.merge(donor: current_user))
    if @pledge.save
      flash[:success] = 'Pledged'
      redirect_to @pledge
    else
      flash[:danger] = @pledge.errors.full_messages.join("; ")
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
      params.require(:pledge).permit(:amount, :read_terms)
    end
end