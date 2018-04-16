class UserMailer < ApplicationMailer
  def confirmation_email
    @user = User.find(params[:user_id])
    @user.create_confirmation_token
    mail(to: @user.unconfirmed_email, subject: t(".subject"))
  end
end
