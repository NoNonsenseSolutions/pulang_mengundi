# frozen_string_literal: true

class Profiles::PhoneVerificationsController < ApplicationController
  before_action :set_user

  def new
    @verification = @user.phone_verification || @user.build_phone_verification
  end

  def create
    @verification = @user.phone_verification || @user.build_phone_verification
    @service = SendPhoneVerificationCodeService.new(verification: @verification, phone_verification_params: phone_verification_params)

    if @service.perform
      redirect_to %i[profiles phone_verifications]
    else
      flash.now[:danger] = @service.error
      render :new
    end
  end

  def show
    @verification = @user.phone_verification
    redirect_to %i[new profiles phone_verifications] unless @verification.present? && @verification.phone_subscriber_number.present?
  end

  def update
    @verification = @user.phone_verification
    redirect_to %i[new profiles phone_verifications] unless @verification.present? && @verification.verification_code.present?

    if @verification.verification_code == params.dig(:phone_verification, :user_verification_code)
      @verification.phone_verified!
      flash[:success] = t('.phone_verified')
      redirect_back_or profiles_path
    else
      flash[:danger] = t('.verification_code_not_match')
      redirect_to %i[profiles phone_verifications]
    end
  end

  private

  def set_user
    @user = current_user
  end

  def phone_verification_params
    params.require(:phone_verification).permit(:phone_area_code, :phone_subscriber_number)
  end
end
