# frozen_string_literal: true

class User < ApplicationRecord
  include EmailConfirmation
  has_many :linked_accounts, dependent: :destroy
  has_one :request, foreign_key: :requester_id, class_name: 'Request', dependent: :destroy
  has_many :reports, foreign_key: :reported_id, class_name: 'Report'
  has_many :pledges, foreign_key: :donor_id, class_name: 'Pledge'

  delegate :link, :email, to: :facebook, prefix: true, allow_nil: true
  delegate :link, :email, to: :twitter, prefix: true, allow_nil: true

  validate :phone_is_valid

  EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\z/
  validates :email, format: { with: EMAIL_REGEX, message: 'invalid email' },
                    uniqueness: true,
                    allow_nil: true

  validates :unconfirmed_email, format: { with: EMAIL_REGEX, message: 'invalid email' }, allow_blank: true

  def expired_request_pledges
    request&.pledges&.has_expired || []
  end

  def donor_transferred_request_pledges
    request&.pledges&.donor_transferred || []
  end

  def profile_incomplete?
    missing_social_link? || emails.empty?
  end

  def emails
    [facebook_email, twitter_email, email].reject(&:nil?).uniq
  end

  def missing_social_link?
    facebook_link.nil? || twitter_link.nil?
  end

  def reported?(user)
    Report.where(reporter: self, reported: user).exists?
  end

  def can_still_pledge?
    pledges.waiting_for_transfer.count > 1
  end

  def pending_requests
    Request.joins(:pledges).where(pledges: { donor: self, status: Pledge.statuses[:waiting_for_transfer] })
  end

  def waiting_for_transfer_pledge_for(request)
    request.pledges.waiting_for_transfer.where(donor: self).first
  end

  def phone
    phone_area_code + phone_number
  end

  private

  def facebook
    linked_accounts.find_by(provider: 'facebook')
  end

  def twitter
    linked_accounts.find_by(provider: 'twitter')
  end

  def phone_is_valid
    return unless phone_number.present?
    return if TelephoneNumber.parse(phone).valid?
    errors.add(:phone_number, 'is invalid')
  end
end
