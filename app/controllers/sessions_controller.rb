# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :check_logged_in, only: :new
  def new; end

  def create
    if request.env['omniauth.auth']
      begin
        user = LinkedAccount.create_with_omniauth(request.env['omniauth.auth'], current_user)
        if user.flagged
          flash[:danger] = t('.flagged_account')
          redirect_to root_path
        else
          sign_in(:user, user)
          # Change to last path
          flash['success'] = "Signed in as #{user.name}"
          redirect_back_or(root_path)
        end
      rescue LinkedAccount::UserOverwrittenError
        flash[:danger] = t('.failed_to_link_account')
        redirect_back_or(root_path) && return
      end
    end
  end

  def localized
    session.delete(:forwarding_url)
    session[:omniauth_login_locale] = params[:locale]
    redirect_to "/auth/#{params[:provider]}"
  end

  def destroy
    sign_out(current_user) if current_user
    flash[:success] = t('.logged_out')
    redirect_to root_path
  end

  private

  def check_logged_in
    return unless current_user
    flash[:danger] = t('sessions.already_logged_in')
    redirect_to root_path
  end
end
