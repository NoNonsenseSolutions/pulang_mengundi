class Request < ApplicationRecord
  TRANSPORT_TYPES = ["FLIGHT", "BUS", "TRAIN"]
  belongs_to :requester, class_name: 'User'
  has_many :pledges, dependent: :destroy

  has_many_attached :supporting_documents

  validates :bank_name, presence: true, inclusion: { in: Bank::NAMES, message: 'must be in the list of banks' }
  validates :account_number, 
    presence: true, uniqueness: { scope: :bank_name }, 
    format: { with: /\A\d+\z/, message: "can only contain numbers" }
  validates :account_name, presence: true
  validates :transport_type, inclusion: {in: TRANSPORT_TYPES}
  validates :target_amount, inclusion: {in: 10..5000, message: 'has to be between 10 to 5000'}
  validates :requester_id, uniqueness: true

  validate :cap_target_amount

  after_create :update_remaining_balance!

  def display_pic
    requester.profile_pic
  end

  def disputed_pledges_count
    pledges.select { |p| p.requester_disputed? }.length
  end


  def remaining_balance_percentage
    (remaining_balance / self.target_amount.to_f * 100).to_i
  end

  def successful_pledges_amount
    pledges.requester_received.sum(:amount)
  end

  def pending_pledges_amount
    pledges.pending.sum(:amount)
  end

  def successful_pledges_percentage
    (pledges.requester_received.sum(:amount) / self.target_amount.to_f * 100).to_i
  end

  def disputed_pledges_percentage
    (pledges.requester_disputed.sum(:amount) / self.target_amount.to_f * 100).to_i
  end

  def pending_pledges_percentage
    (pledges.pending.sum(:amount) / self.target_amount.to_f * 100).to_i
  end

  def update_remaining_balance!
    self.remaining_balance = target_amount - pledges.active.sum(:amount)
    save!
  end

  private
    def cap_target_amount
      if target_amount > (0.9 * travelling_fees)
        errors.add(:target_amount, "- Cannot request more than 90\% of travelling fees")
      end
    end
end
