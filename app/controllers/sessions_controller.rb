class SessionsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :check_logged_in, only: :new
  def new
  end

  def create
    if request.env['omniauth.auth']
      begin
        user = LinkedAccount.create_with_omniauth(request.env['omniauth.auth'], current_user)
      
        session[:user_id] = user.id

        # Change to last path
        flash["success"] = "Signed in as #{user.name}"
        redirect_back_or(root_path)
      rescue LinkedAccount::UserOverwrittenError
        flash[:danger] = t('.failed_to_link_account')
        redirect_back_or(root_path) and return
      end
    end
  end

  def localized
    session.delete(:forwarding_url)
    session[:omniauth_login_locale] = params[:locale]
    redirect_to "/auth/#{params[:provider]}"
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = t('.logged_out')
    redirect_to root_path
  end

  private
    def check_logged_in
      if user_logged_in?
        flash[:danger] = t('sessions.already_logged_in')
        redirect_to root_path 
      end
    end
end