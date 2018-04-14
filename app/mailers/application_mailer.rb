class ApplicationMailer < ActionMailer::Base
  default from: ENV['MAILGUN_DEFAULT_FROM']
  layout 'mailer'
end
