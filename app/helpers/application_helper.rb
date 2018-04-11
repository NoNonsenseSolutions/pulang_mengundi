module ApplicationHelper
  def user_logged_in?
    session[:user_id] && current_user
  end

  def current_user
    User.find_by id: session[:user_id]
  end

  def authenticate_user!
    redirect_to new_sessions_path unless user_logged_in?
  end
end
