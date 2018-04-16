class ProfilesController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(profile_params)
      if params.dig(:user, :email).present? && (@user.email != params.dig(:user, :email))
        @user.unconfirmed_email = params.dig(:user, :email)
        if @user.save
          UserMailer.with(user_id: @user.id).confirmation_email.deliver_later
          flash[:success] = t('.check_email')
        else
          flash[:danger] = t('.invalid_email')
        end
      else
        flash[:success] = t('.success')
      end      
    else
      flash[:danger] = @user.errors.full_messages.join("; ")
    end
    redirect_back(fallback_location: edit_profiles_path)
  end

  private
    def profile_params
      params.require(:user).permit(:phone_area_code, :phone_number, :email_public, :ic)
    end
end