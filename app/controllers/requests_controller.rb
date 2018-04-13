class RequestsController < ApplicationController
  def index
    @requests = Request.where('remaining_balance > ?', 0).order(created_at: :asc)
    @total_number_of_requests = Request.count
    @total_amount_pledged = Pledge.requester_received.sum(:amount)
  end

  def new
    if current_user.request.present?
      flash[:danger] = 'You can only create one request'
      redirect_to current_user.request
    else
      @request = Request.new
    end
  end

  def create
    @request = current_user.build_request(request_params)
    if @request.save
      flash[:success] = 'Request created'
      redirect_to [@request, :thank_you_screens]
    else
      flash[:danger] = @request.errors.full_messages.join("; ")
      render :new
    end
  end

  def show
    @request = Request.find(params[:id])
    @requester = @request.requester
    @pledge = Pledge.new
  end

  def edit
    @request = Request.find(params[:id])
    authorize @request
  end

  def update
    @request = Request.find(params[:id])
    authorize @request
    if @request.update(request_params)
      flash[:success] = 'Request updated'
      redirect_to @request
    else
      flash[:danger] = @request.errors.full_messages.join("; ")
      render :new
    end
  end

  private
    def request_params
      params.require(:request).permit(:bank_name, :account_number, 
        :account_name, :transport_type, :to_state, :to_city, 
        :description, :travelling_fees, :target_amount, :itinerary, 
        :travel_company, supporting_documents: [])
    end
end