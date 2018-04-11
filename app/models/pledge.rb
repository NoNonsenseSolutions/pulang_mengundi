class Pledge < ApplicationRecord
  belongs_to :donor, class_name: 'User'
  belongs_to :request
  validates :amount, inclusion: 10..10000
  validate :donor_cannot_be_requester

  enum donor_status: { pending_donor: 0, donor_transferred: 10, donor_expired: 20 }
  enum requester_status: { pending_requester: 0, requester_received: 10, requester_disputed: 20 }


  def waiting_for_donor_response?
    pending_donor? && !expired?
  end

  def expired?
    return true if donor_expired?
    return false if donor_transferred?

    if pending_donor? && (created_at < 2.hours.ago)
      self.donor_status == "expired"
      self.save
      return true
    else
      return false
    end
  end

  private
    def donor_cannot_be_requester
      if request.requester == donor
        errors.add(:donor, 'cannot pledge to your own subsidy request')
      end
    end
end
