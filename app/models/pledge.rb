class Pledge < ApplicationRecord
  belongs_to :donor, class_name: 'User'
  belongs_to :request
  validates :amount, presence: true, inclusion: {in: 0..5000, message: 'has to be between 10 to 5000'}
  validates :read_terms, inclusion: { in: [true], message: '- please confirm that you have read the T&C' }
  validate :donor_cannot_be_requester

  validate :cannot_pledge_above_remaining_amount, on: :create

  scope :active, -> { where(status: [0, 10, 20]) }
  scope :pending, -> { where(status: [0, 10]) }
  enum status: { waiting_for_transfer: 0, donor_transferred: 10, requester_received: 20, requester_disputed: 30, expired: 40 }

  def pending?
    waiting_for_transfer? || donor_transferred?
  end

  def past_expiry?
    created_at < 2.hours.ago
  end
  private
    def donor_cannot_be_requester
      if request.requester == donor
        errors.add(:donor, 'cannot pledge to your own subsidy request')
      end
    end

    def cannot_pledge_above_remaining_amount
      if amount && (request.remaining_amount < amount)
        errors.add(:amount, " RM #{amount} exceeds the remaining subsidy requested for. Choose a smaller amount, or wait for some pending pledges to be voided")
      end
    end
end
