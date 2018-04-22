# == Schema Information
#
# Table name: requests
#
#  id                :integer          not null, primary key
#  bank_name         :string
#  account_number    :string
#  account_name      :string
#  description       :text
#  transport_type    :string
#  to_city           :string
#  to_state          :string
#  travelling_fees   :decimal(8, 2)    default(0.0)
#  target_amount     :decimal(8, 2)    default(0.0)
#  requester_id      :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  itinerary         :text
#  travel_company    :string
#  remaining_balance :decimal(8, )
#  disabled_at       :datetime
#  total_received    :decimal(8, 3)    default(0.0)
#

class Request < ApplicationRecord
  TRANSPORT_TYPES = ["FLIGHT", "BUS", "TRAIN"]

  belongs_to :requester, class_name: 'User'
  has_many :pledges, dependent: :destroy
  has_many_attached :supporting_documents

  attr_accessor :is_disabled
  accepts_nested_attributes_for :supporting_documents_attachments, allow_destroy: true

  validates :bank_name, presence: true, inclusion: { in: Bank::NAMES, message: 'must be in the list of banks' }
  validates :account_number,
    presence: true, uniqueness: { scope: :bank_name },
    format: { with: /\A\d+\z/, message: "can only contain numbers" }
  validates :account_name, presence: true
  validates :transport_type, inclusion: {in: TRANSPORT_TYPES}
  validates :target_amount, inclusion: {in: 10..5000, message: 'has to be between 10 to 5000'}
  validates :requester_id, uniqueness: true
  validates :travelling_fees, presence: true, numericality: {greater_than_or_equal_to: 0}

  validate :user_has_read_terms, on: :create

  validate :cap_target_amount

  before_save :update_remaining_balance!
  before_update :purge_supporting_documents

  scope :without_disabled, -> { where(disabled_at: nil) }

  # Searchkick
  searchkick

  scope :search_import, -> { includes(:requester).with_attached_supporting_documents }
  def search_data
    {
      id_string: id.to_s,
      requester_name: requester.name,
      bank_name: bank_name,
      description: description,
      transport_type: transport_type,
      to_city: to_city,
      to_state: to_state,
      target_amount: target_amount,
      requester_id: requester_id,
      travel_company: travel_company,
      remaining_balance: remaining_balance,
      created_at: created_at,
      disabled_at:  disabled_at,
      total_received: total_received,
      requester_age: requester.estimated_age,
      is_disabled: disabled_at.present?,
      has_itinerary: itinerary.present?,
      has_supporting_documents: supporting_documents.present?,
      is_completed: completed?
    }
  end

  def disputes
    Dispute.where(pledge_id: self.pledges.pluck(:id))
  end

  def display_pic
    requester.profile_pic
  end

  def disputed_pledges_count
    disputes.length
  end

  def completed?
    target_amount == total_received
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
  end

  def update_total_received!
    self.total_received = pledges.requester_received.sum(:amount)
    save!
  end

  def disable!
    self.disabled_at = Time.zone.now
    save
  end

  def enable!
    self.disabled_at = nil
    save
  end

  def disabled?
    !self.disabled_at.nil?
  end

  private
    def cap_target_amount
      if target_amount && travelling_fees && target_amount > (0.9 * travelling_fees)
        errors.add(:target_amount, "- Cannot request more than 90\% of travelling fees")
      end
    end

    def user_has_read_terms
      errors.add(:requester, 'has not agreed to the terms and conditions') unless requester.read_terms?
    end

    def purge_supporting_documents
      supporting_documents.each do |supporting_document|
        if supporting_document.marked_for_destruction?
          supporting_document.blob.purge_later
        end
      end
    end
end
