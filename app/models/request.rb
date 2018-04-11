class Request < ApplicationRecord
  belongs_to :requester, class_name: 'User'
  has_many :pledges, dependent: :destroy

  validates :target_amount, inclusion: 30..10000


  TRANSPORT_TYPES = ["FLIGHT", "BUS", "TRAIN"]

  def display_pic
    requester.profile_pic
  end

  def successful_pledges
    pledges.requester_received
  end

  def disputed_pledges
    pledges.requester_disputed
  end

  def successful_pledges_amount
    successful_pledges.sum(:amount)
  end

  def disputed_pledges_amount
    disputed_pledges.sum(:amount)
  end

  def successful_pledges_percentage
    (successful_pledges_amount / self.target_amount.to_f * 100).to_i
  end

  def disputed_pledges_percentage
    (disputed_pledges_amount / self.target_amount.to_f * 100).to_i
  end
end
