class Administrator::UsersQuery
  attr_reader :search_term, :selected_order

  def initialize params: params, relation: User.all
    @relation       = relation
    @search_term    = params[:search_term]
    @page           = params[:page]
    @per_page       = params[:per_page]
    @selected_order = params[:selected_order]
  end

  def order_options
    [
      ['Relevance', ''],
      ['Newest First', 'created_at_desc'],
      ['Oldest First', 'created_at_asc']
    ]
  end

  def results
    order_hash = { order_column => order_direction } if selected_order.present?

    User.search(
      search_term,
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
      else
        raise(ArgumentError, "Invalid sort option: #{ selected_order }")
      end
    end

    def order_direction
      direction = (selected_order =~ /desc$/) ? 'desc' : 'asc'
    end
end