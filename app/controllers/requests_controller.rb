class RequestsController < ApplicationController
  skip_before_action :authenticate_user!, only: :show

  def index
    @requests = policy_scope(Request).without_disabled.where('remaining_balance > ?', 0)

    @search_state_seat = params.dig(:search, :state_seat)
    if @search_state_seat.present?
      if ElectoralDistrict::STATES.include?(@search_state_seat)
        @requests = @requests.where(to_state: @search_state_seat)
      else
        @requests = @requests.where(to_city: @search_state_seat)
      end
    end

    @bank_name = params.dig(:search, :bank_name)
    if @bank_name.present?
      @requests = @requests.where(bank_name: @bank_name)
    end

    @search_order = params.dig(:search, :order)
    Request.connection.execute("SELECT setseed(#{ Time.zone.now.hour / 24.0})")
    if @search_order.present?
      if @search_order == 'Highest Balance'
        @requests = @requests.order(remaining_balance: :desc)
      elsif @search_order == 'Lowest Balance'
        @requests = @requests.order(remaining_balance: :asc)
      end
    end

    @search_document_provided = params.dig(:search, :document_provided)
    if @search_document_provided.present?
      user_ids = ActiveStorageAttachment.where(record_type: "Request").pluck(:record_id).uniq
      
      if user_ids.empty?
        user_ids = [0]
      end

      if @search_document_provided == 'Yes'
        @requests = @requests.where("id IN (?)", user_ids)
      elsif @search_document_provided == 'No'
        @requests = @requests.where("id NOT IN (?)", user_ids)
      end
    end

    @search_date_created = params.dig(:search, :date_created)
    if @search_date_created.present?
      if @search_date_created == 'Newest'
        @requests = @requests.order(created_at: :desc)
      elsif @search_date_created == 'Oldest'
        @requests = @requests.order(created_at: :asc)
      elsif @search_date_created == 'Random'
        @requests = @requests.order("RANDOM()")
      end
    else
      @requests = @requests.order("RANDOM()")
    end

    @requests = @requests.paginate(:page => params[:page], :per_page => 50)

    @total_number_of_requests = Request.count
    @total_amount_pledged = Pledge.requester_received.sum(:amount)
  end

  def new
    @user = current_user

    unless @user.mandatory_information_for_request_complete?
      flash[:danger] = t('.missing_ic')
      store_location
      redirect_to edit_profiles_path and return
    end

    unless @user.read_terms?
      store_location
      redirect_to terms_and_conditions_path and return
    end
    
    @request = Request.new
    authorize @request
  end

  def create
    @request = current_user.build_request(request_params)
    authorize @request

    if verify_recaptcha(model: @request) && @request.save
      flash[:success] = t('.success')
      redirect_to [@request, :thank_you_screens]
    else
      flash[:danger] = @request.errors.full_messages.join("; ")
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
      flash[:success] = t('.success')
      redirect_to @request
    else
      flash[:danger] = @request.errors.full_messages.join("; ")
      render :edit
    end
  end

  private
    def request_params
      params.require(:request).permit(:bank_name, :account_number,
        :account_name, :transport_type, :to_state, :to_city,
        :description, :travelling_fees, :target_amount, :itinerary,
        :travel_company, :read_terms, supporting_documents: [])
    end
end
