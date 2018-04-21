# frozen_string_literal: true

module Administrator
  class ApplicationController < ActionController::Base
    layout 'admin/application'

    before_action :authenticate_admin!
  end
end
