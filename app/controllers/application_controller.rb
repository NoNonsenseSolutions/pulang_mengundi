# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pundit
  before_action :authenticate_user!
  before_action :initialize_notification_presenter
  before_action :prompt_tnc
  before_action :set_locale

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def initialize_notification_presenter
    @notification_presenter = NotificationPresenter.new(current_user)
  end

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    flash[:danger] = t "#{policy_name}.#{exception.query}", scope: 'pundit', default: :default
    redirect_to(request.referrer || root_path)
  end

  def prompt_tnc
    return unless current_user&.request && !current_user.read_terms
    store_location
    redirect_to terms_and_conditions_path
  end

  def default_url_options(_options = {})
    { locale: I18n.locale }
  end

  def set_locale
    I18n.locale = params[:locale] if params[:locale].present?
    # redirect back to home page if user typed in URL such as /my
  rescue StandardError
    redirect_to root_path(locale: :en)
  end
end
