# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def confirmation_email
    @user = User.find(params[:user_id])
    @user.create_confirmation_token
    mail(to: @user.unconfirmed_email, subject: t('.subject'))
  end

  def update_information_email
    @email = params[:email]

    attachments.inline['my_request.png'] = File.read('app/assets/images/mailer_attachments/my_request.png')
    attachments.inline['manage_my_request.png'] = File.read('app/assets/images/mailer_attachments/manage_my_request.png')
    attachments.inline['edit_request.png'] = File.read('app/assets/images/mailer_attachments/edit_request.png')
    mail(to: @email, subject: "Update your details on pulangmengundi.com by May 1, 2018")
  end
end
