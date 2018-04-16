# frozen_string_literal: true

class EmailConfirmationsController < ApplicationController
  skip_before_action :authenticate_user!
  def show
    user = User.find_by(unconfirmed_email: params[:email])

    if user&.email_confirmation?(params[:id])
      if user.update(email: params[:email], confirmed_at: Time.zone.now, unconfirmed_email: nil)
        flash[:success] = 'Email confirmed!'
      else
        flash[:danger] = user.errors.full_messages.join('; ')
      end
    else
      flash[:danger] = 'Invalid confirmation link'
    end

    redirect_to root_path
  end
end
