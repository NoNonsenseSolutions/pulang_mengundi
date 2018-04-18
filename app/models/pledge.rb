class Pledge < ApplicationRecord
  EXPIRY_TIME = 2.hours.ago
  belongs_to :donor, class_name: 'User'
  belongs_to :request

  has_one_attached :receipt

  has_many :disputes, dependent: :destroy

  after_save :update_request_balance
  after_save :update_request_total_received

  validates :amount, presence: true, inclusion: {in: 0..5000, message: 'has to be between 10 to 5000'}
  validate :donor_cannot_be_requester
  validate :cannot_pledge_above_remaining_balance, on: :create

  validate :cannot_have_more_than_two_pending_pledge, on: :create

  validate :user_has_read_terms, on: :create

  scope :active, -> { where(status: [0, 10, 20]) }
  scope :pending, -> { where(status: [0, 10]) }
  scope :has_expired, -> { waiting_for_transfer.where('created_at < ?', EXPIRY_TIME) }
  enum status: { waiting_for_transfer: 0, donor_transferred: 10, requester_received: 20, requester_disputed: 30, expired: 40 }

  def pending?
    waiting_for_transfer? || donor_transferred?
  end

  def past_expiry?
    created_at < EXPIRY_TIME
  end
  private
    def donor_cannot_be_requester
      if request.requester == donor
        errors.add(:donor, 'cannot pledge to your own subsidy request')
      end
    end

    def cannot_pledge_above_remaining_balance
      if amount && (request.remaining_balance < amount)
        errors.add(:amount, " RM #{amount} exceeds the remaining subsidy requested for. Choose a smaller amount, or wait for some pending pledges to be voided")
      end
    end

    def update_request_balance
      request.update_remaining_balance!
      request.save
    end

    def update_request_total_received
      request.update_total_received!
    end

    def cannot_have_more_than_two_pending_pledge
      unless donor.can_pledge?
        errors.add(:donor, "cannot have more than two pending pledges. If you've uploaded the receipt, please get the requester to confirm receipt")
      end
    end

    def user_has_read_terms
      errors.add(:donor, 'has not read the terms and conditions') unless donor.read_terms?
    end
end
