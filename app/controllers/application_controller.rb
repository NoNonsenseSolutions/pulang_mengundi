class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pundit
  before_action :authenticate_user!
  before_action :initialize_notification_presenter

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def initialize_notification_presenter
    @notification_presenter = NotificationPresenter.new(current_user)
  end

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    flash[:danger] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
    redirect_to(request.referrer || root_path)
  end

end
