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

  def user_logged_in?
    session[:user_id] && current_user
  end

  def current_user
    User.find_by id: session[:user_id]
  end

  def authenticate_user!
    return if user_logged_in?
    store_location
    redirect_to new_sessions_path
  end
end
