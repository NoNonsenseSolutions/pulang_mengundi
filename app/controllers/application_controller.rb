class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private
    def logged_in_user?
      session[:user_id].present?
    end

    def current_user
      User.find_by id: session[:user_id]
    end

    def authenticate_user!
      redirect_to new_session_path unless logged_in_user?
    end
end
