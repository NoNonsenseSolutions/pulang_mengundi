# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: ENV['MAILGUN_DEFAULT_FROM']
  layout 'mailer'

  def default_url_options
    { locale: I18n.locale }
  end
end
