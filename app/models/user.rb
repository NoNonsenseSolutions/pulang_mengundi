# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  hashed_phone         :string
#  phone_verified_at    :datetime
#  name                 :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  profile_pic          :string
#  unconfirmed_email    :string
#  email                :string
#  phone_number         :string
#  phone_area_code      :string
#  confirmation_token   :string
#  confirmation_sent_at :datetime
#  confirmed_at         :datetime
#  email_public         :boolean          default(FALSE)
#  ic                   :string
#  read_terms           :boolean          default(FALSE)
#

class User < ApplicationRecord
  include EmailConfirmation
  devise :authenticatable

  has_many :linked_accounts, dependent: :destroy
  has_one :request, foreign_key: :requester_id, class_name: 'Request', dependent: :destroy
  has_many :reports, foreign_key: :reported_id, class_name: 'Report'
  has_many :pledges, foreign_key: :donor_id, class_name: 'Pledge'
  has_one :phone_verification, dependent: :destroy

  has_one_attached :ic_picture

  delegate :link, :email, :search_link, to: :facebook, prefix: true, allow_nil: true
  delegate :link, :email, to: :twitter, prefix: true, allow_nil: true

  validates :read_terms, inclusion: { in: [true], message: '- please confirm that you have read the T&C' }, on: :tnc_prompt

  EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\z/
  validates :email, format: { with: EMAIL_REGEX, message: 'invalid email' },
                    uniqueness: true,
                    allow_nil: true

  IC_REGEX = /\A([0-9][0-9])((0[1-9])|(1[0-2]))((0[1-9])|([1-2][0-9])|(3[0-1]))\-([0-9][0-9])\-([0-9][0-9][0-9][0-9])\z/
  validates :ic, format: { with: IC_REGEX, message: 'invalid ' },
                 length: { is: 14 },
                 uniqueness: true,
                 allow_nil: true

  validates :unconfirmed_email, format: { with: EMAIL_REGEX, message: 'invalid email' }, allow_blank: true

  # Searchkick
  searchkick

  def search_data
    {
      id_string: id.to_s,
      name: name,
      email: email,
      phone: phone,
      ic: ic,
      created_at: created_at
    }
  end

  def expired_request_pledges
    request&.pledges&.has_expired || []
  end

  def donor_transferred_request_pledges
    request&.pledges&.donor_transferred || []
  end

  def mandatory_information_for_request_complete?
    email.present? && ic.present?
  end

  def profile_incomplete?
    emails.empty? || !phone_verified? || !ic_verified?
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

  def pending_requests
    Request.joins(:pledges).where(pledges: { donor: self, status: Pledge.statuses[:waiting_for_transfer] })
  end

  def waiting_for_transfer_pledge_for(request)
    request.pledges.waiting_for_transfer.where(donor: self).first
  end

  def phone
    "#{phone_area_code}#{phone_number}"
  end

  def estimated_age
    return nil unless ic
    now = Time.zone.now
    dob = Date.parse("19#{ic.first(7)}")
    now.year - dob.year - (now.month > dob.month || (now.month == dob.month && now.day >= dob.day) ? 0 : 1)
  end

  def phone_verified?
    phone_verified_at.present?
  end

  def ic_verified?
    ic_verified_at.present?
  end

  private

  def facebook
    linked_accounts.find_by(provider: 'facebook')
  end

  def twitter
    linked_accounts.find_by(provider: 'twitter')
  end
end
