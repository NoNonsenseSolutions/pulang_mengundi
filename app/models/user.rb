class User < ApplicationRecord
  has_many :linked_accounts, dependent: :destroy  
  has_one :request, foreign_key: :requester_id, class_name: 'Request', dependent: :destroy
  has_many :reports, foreign_key: :reported_id, class_name: 'Report'

  def has_actionable_pledge?
    request && request.pledges.donor_transferred.exists?
  end

  def facebook_link
    linked_accounts.find_by(provider: 'facebook')&.link
  end

  def twitter_link
    linked_accounts.find_by(provider: 'twitter')&.link
  end

  def reported?(user)
    Report.where(reporter: self, reported: user).exists?
  end
end
