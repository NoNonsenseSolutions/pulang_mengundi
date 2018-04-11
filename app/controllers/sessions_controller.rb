class SessionsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :check_logged_in, only: :new
  def new
  end

  def create
    if request.env['omniauth.auth']
      user = LinkedAccount.create_with_omniauth(request.env['omniauth.auth'], current_user)
      session[:user_id] = user.id

      # Change to last path
      redirect_to new_request_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "Logged out"
    redirect_to root_path
  end

  private
    def check_logged_in
      if user_logged_in?
        flash[:danger] = 'Already logged in'
        redirect_to root_path 
      end
    end
end