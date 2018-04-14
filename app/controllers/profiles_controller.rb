class ProfilesController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(profile_params)
      if @user.email != params.dig(:user, :email)
        @user.unconfirmed_email = params.dig(:user, :email)
        @user.save
        UserMailer.with(user_id: @user.id).confirmation_email.deliver_later
        flash[:success] = "Please check your email to verify your email."
      else
        flash[:success] = "Profile Updated"
      end      
    else
      flash[:danger] = @user.errors.full_messages.join("; ")
    end
    redirect_back(fallback_location: edit_profiles_path)
  end

  private
    def profile_params
      params.require(:user).permit(:phone_area_code, :phone_number, :email_public)
    end
end