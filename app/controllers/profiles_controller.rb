class ProfilesController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = User.find_by(id: params[:user_id]) || current_user
    if @user.update(profile_params)
      if params.dig(:user, :email).present? && (@user.email != params.dig(:user, :email))
        @user.unconfirmed_email = params.dig(:user, :email)
        if @user.save
          UserMailer.with(user_id: @user.id).confirmation_email.deliver_later
          flash[:success] = t('.check_email') if request.format.html?
        else
          flash[:danger] = t('.invalid_email') if request.format.html?
        end
      else
        flash[:success] = t('.success') if request.format.html?
      end
    else
      flash[:danger] = @user.errors.full_messages.join("; ") if request.format.html?
    end

    respond_to do |format|
      format.json { render json: { message: @user.errors.full_messages.join("; ") }, status: @user.valid? ? :accepted : :bad_request }
      format.html { redirect_back_or(edit_profiles_path) }
    end
  end

  private
    def profile_params
      params.require(:user).permit(:phone_area_code, :phone_number, :email_public, :ic, :flagged)
    end
end