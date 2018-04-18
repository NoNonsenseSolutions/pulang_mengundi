module Administrator
  class UsersController < Administrator::ApplicationController
    def index
      @users = User.order(:name).page(params[:page])
    end
  end
end
