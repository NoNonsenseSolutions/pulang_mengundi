# frozen_string_literal: true

class PhoneVerification < ApplicationRecord
  attr_reader :user_verification_code
  belongs_to :user
  validates :phone_area_code, presence: true
  validates :phone_subscriber_number, presence: true
  validate :phone_is_valid

  def phone
    "#{phone_area_code}#{phone_subscriber_number}"
  end

  def generate_verification_code
    self.verification_code = rand(0o00000..999_999).to_s.rjust(6, '0')
    save
  end

  def phone_verified!
    return if user.phone_verified?
    user.phone_verified_at = Time.zone.now
    user.phone_area_code = phone_area_code
    user.phone_number = phone_subscriber_number
    user.save!
  end

  private

  def phone_is_valid
    return unless phone.present?
    return if TelephoneNumber.parse(phone).valid?
    errors.add(:phone_number, 'is invalid')
  end
end
