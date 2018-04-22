# frozen_string_literal: true

module Administrator
  class PasswordsController < Devise::PasswordsController
    layout 'admin/application'

    skip_before_action :authenticate_user!
  end
end
