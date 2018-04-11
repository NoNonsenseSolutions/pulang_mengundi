class Request < ApplicationRecord
  belongs_to :requester, class_name: 'User'
  has_many :pledges, dependent: :destroy

  validates :target_amount, inclusion: {in: 10..5000, message: 'has to be between 10 to 5000'}


  TRANSPORT_TYPES = ["FLIGHT", "BUS", "TRAIN"]

  def display_pic
    requester.profile_pic
  end

  def remaining_amount
    target_amount - pledges.active.sum(:amount) 
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
end
