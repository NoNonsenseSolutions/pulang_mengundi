# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def confirmation_email
    @user = User.find(params[:user_id])
    @user.create_confirmation_token
    mail(to: @user.unconfirmed_email, subject: 'Confirm your email to for pulangmengundi.com')
  end
end
