class Administrator::RequestIndexQuery
  attr_reader :to_state, :to_city, :selected_order, :transport_type

  def initialize params: params, relation: Request.all
    @relation       = relation
    @search_term    = params.dig(:filter, :search_term)
    @to_state       = params.dig(:filter, :to_state)
    @to_city        = params.dig(:filter, :to_city)
    @transport_type = params.dig(:filter, :transport_type)
    @page           = params.dig(:page)
    @per_page       = params.dig(:per_page)
    @selected_order = params.dig(:filter, :selected_order)
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
    where_hash[:to_city]  = to_city if to_city.present?
    where_hash[:transport_type]  = transport_type if transport_type.present?

    order_hash = { order_column => order_direction } if selected_order.present?

    Request.search(
      search_term, 
      where: where_hash,
      includes: [:requester], 
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