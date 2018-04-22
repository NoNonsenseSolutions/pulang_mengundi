class Administrator::RequestsQuery
  attr_reader :to_state, :to_city, :selected_order, :transport_type, :min_age, :max_age, :has_itinerary, :has_supporting_documents, :is_disabled, :is_completed

  def initialize params: params, relation: Request.all
    @relation                 = relation
    @search_term              = params[:search_term]
    @to_state                 = params[:to_state]
    @to_city                  = params[:to_city]
    @transport_type           = params[:transport_type]
    @page                     = params[:page]
    @per_page                 = params[:per_page]
    @selected_order           = params[:selected_order]
    @min_age                  = params[:min_age]
    @max_age                  = params[:max_age]
    @has_itinerary            = params[:has_itinerary]
    @has_supporting_documents = params[:has_supporting_documents]
    @is_disabled              = params[:is_disabled].nil? ? "false" : params[:is_disabled]
    @is_completed             = params[:is_completed].nil? ? "false" : params[:is_completed]
  end

  def order_options
    [
      ['Relevance', ''],
      ['Newest First', 'created_at_desc'],
      ['Oldest First', 'created_at_asc'],    
      ['Highest target amount', 'target_amount_desc'], 
      ['Lowest target amount', 'target_amount_asc'], 
    ]
  end

  def results
    where_hash = Hash.new

    where_hash[:to_state] = to_state if to_state.present?
    where_hash[:to_city] = to_city if to_city.present?
    where_hash[:transport_type] = transport_type if transport_type.present?
    where_hash[:has_itinerary] = has_itinerary if has_itinerary.present?
    where_hash[:has_supporting_documents] = has_supporting_documents if has_supporting_documents.present?
    where_hash[:is_completed] = is_completed if is_completed.present?

    #FFFFFF

    if min_age.present? && max_age.present?
      where_hash[:requester_age] = min_age..max_age
    end

    order_hash = { order_column => order_direction } if selected_order.present?

    Request.search(
      search_term, 
      where: where_hash,
      includes: [requester: :linked_accounts], 
      scope_results: ->(r) { r.with_attached_supporting_documents },
      page: page,
      per_page: per_page,
      order: order_hash
    )
  end

  def page
    @page.present? ? @page : 1
  end

  def per_page
    @per_page.present? ? @per_page : 20
  end

  def search_term
    @search_term.present? ? @search_term : '*'
  end

  private
    def order_column
      case selected_order
      when /^created_at/
        :created_at
      when /^target_amount/
        :target_amount
      else
        raise(ArgumentError, "Invalid sort option: #{ selected_order }")
      end
    end

    def order_direction
      direction = (selected_order =~ /desc$/) ? 'desc' : 'asc'
    end
end