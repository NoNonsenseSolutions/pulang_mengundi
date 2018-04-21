# frozen_string_literal: true

module Administrator
  class AdminsController < Administrator::ApplicationController
    def index
      @admins = Admin.order(:name).page(params[:page])
    end

    def new
      @admin = Admin.new
    end

    def create
      @admin = Admin.new(new_admin_params.merge(password: SecureRandom.hex))

      if @admin.save
        @admin.send_reset_password_instructions
        flash[:success] = "Admin created. An email has been sent to #{@admin.email}"
        redirect_to administrator_admins_path
      else
        flash[:danger] = @admin.errors.full_messages.join(', ').humanize
        redirect_to new_administrator_admin_path
      end
    end

    private

    def new_admin_params
      params.require(:admin).permit(:name, :email)
    end
  end
end
