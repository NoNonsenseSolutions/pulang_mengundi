module Administrator
  class AdminsController < Administrator::ApplicationController
    def index
      @admins = Admin.order(:name).page(params[:page])
    end
  end
end
