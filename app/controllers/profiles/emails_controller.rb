# frozen_string_literal: true

class Profiles::EmailsController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      if user_params[:unconfirmed_email].present?
        UserMailer.with(user_id: @user.id).confirmation_email.deliver_later
        redirect_to edit_profiles_emails_path
      else
        redirect_back_or profiles_path
      end
    else
      flash[:danger] = @user.errors.full_messages.join('; ')
      redirect_to edit_profiles_emails_path
    end
  end

  private

  def user_params
    @user_params ||= params.require(:user).permit(:email, :email_public).tap do |whitelist|
      whitelist[:unconfirmed_email] = whitelist.delete(:email) if whitelist[:email].present? && @user.email != whitelist[:email]
    end
  end
end
