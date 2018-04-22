# frozen_string_literal: true

module SessionsHelper
  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def authenticate_user!
    unless current_user || current_admin
      store_location
      redirect_to new_sessions_path
    end

    return unless current_user&.flagged
    flash[:danger] = t('sessions.create.flagged_account')
    session.clear
  end
end
