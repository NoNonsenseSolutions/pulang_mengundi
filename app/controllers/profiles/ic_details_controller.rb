# frozen_string_literal: true

class Profiles::IcDetailsController < ApplicationController
  before_action :set_user
  before_action :cannot_edit_ic

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t('.ic_updated')
      redirect_back_or profiles_path
    else
      flash[:danger] = @user.errors.full_messages.join('; ')
      redirect_to edit_profiles_ic_details_path
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:ic, :ic_picture)
  end

  def cannot_edit_ic
    redirect_to(root_path, flash: { danger: t('.cannot_edit_ic') }) && return if @user.ic_verified?
  end
end
