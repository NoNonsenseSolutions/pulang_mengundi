class RequestsController < ApplicationController
  def index
    @requests = policy_scope(Request).where('remaining_balance > ?', 0).order(created_at: :asc)
    @total_number_of_requests = Request.count
    @total_amount_pledged = Pledge.requester_received.sum(:amount)
  end

  def new
    @request = Request.new
    authorize @request
  end

  def create
    @request = current_user.build_request(request_params)
    authorize @request
    if @request.save
      flash[:success] = 'Request created'
      redirect_to [@request, :thank_you_screens]
    else
      flash[:danger] = @request.errors.full_messages.join("; ")
      @request.supporting_documents.map(&:purge)
      render :new
    end
  end

  def show
    @request = Request.find(params[:id])
    authorize(@request)
    @requester = @request.requester

    @disputes = Dispute.where(pledge_id: @request.pledges.pluck(:id))
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