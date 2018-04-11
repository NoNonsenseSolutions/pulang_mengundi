class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]
  def home
    @requests = Request.all.order(created_at: :asc)
  end
end