module Administrator
  class RequestsController < Administrator::ApplicationController
    before_action :set_request, only: %i[edit update show]

    def index
      @query = Administrator::RequestIndexQuery.new params: params
      @requests = @query.results
    end

    def edit
    end

    def update
      if @request.update(edit_request_params)
        flash[:success] = 'Request updated'
        redirect_to administrator_request_path(@request)
      else
        flash[:danger] = @request.errors.full_messages.join(', ').humanize
        return render 'administrator/requests/edit'
      end
    end

    def show
    end

    private

    def set_request
      @request = Request.find(params[:id])
    end

    def edit_request_params
      params
        .require(:request)
        .permit(:bank_name, :account_name, :account_name, :description, :transport_type,
                :to_city, :to_state, :travelling_fees, :target_amount, :total_received,
                :itinerary, :travel_company, :remaining_balance, :is_disabled,
                supporting_documents: [], supporting_documents_attachments_attributes: [:id, :_destroy])
        .tap do |parameters|
          parameters[:disabled_at] = parameters[:is_disabled].to_i.zero? ? nil : Time.current
          parameters.delete(:is_disabled)
        end
    end
  end
end
