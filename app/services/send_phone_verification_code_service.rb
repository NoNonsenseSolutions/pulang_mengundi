# frozen_string_literal: true

class SendPhoneVerificationCodeService
  attr_reader :verification, :error, :phone_verification_params
  def initialize(verification:, phone_verification_params:)
    @verification = verification
    @phone_verification_params = phone_verification_params
  end

  def perform
    if phone_did_not_change? && @verification.last_sent_at && @verification.last_sent_at > 5.minutes.ago
      @error = I18n.t('services.send_phone_verification_code_service.wait_five_minutes')
      return false
    end

    if @verification.number_of_times_sent > 5
      @error = I18n.t('services.send_phone_verification_code_service.limit_exceeded')
      return false
    end

    @verification.attributes = phone_verification_params

    unless @verification.save
      @error = @verification.errors.full_messages
      return false
    end

    @verification.generate_verification_code
    @verification.last_sent_at = Time.zone.now
    @verification.save
    SmsServiceJob.perform_later(
      phone: @verification.phone,
      message: I18n.t('services.send_phone_verification_code_service.your_verification_code_is', code: @verification.verification_code)
    )
    true
  end

  private

  def phone_did_not_change?
    verification.phone_area_code == phone_verification_params[:phone_area_code] && verification.phone_subscriber_number == phone_verification_params[:phone_subscriber_number]
  end
end
