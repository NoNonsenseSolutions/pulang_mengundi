class EmailConfirmationsController < ApplicationController
  skip_before_action :authenticate_user!
  def show
    user = User.find_by(unconfirmed_email: params[:email])

    if user && user.email_confirmation?(params[:id]) 
      if user.update(email: params[:email], confirmed_at: Time.zone.now, unconfirmed_email: nil)
        flash[:success] = t('.email_confirmed')
      else
        flash[:danger] = user.errors.full_messages.join("; ")
      end
    else
      flash[:danger] = t('.invalid_confirmation_link')
    end
    
    redirect_to root_path
  end
end