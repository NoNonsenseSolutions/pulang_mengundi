class User < ApplicationRecord
  has_many :linked_accounts, dependent: :destroy  
  has_one :request, foreign_key: :requester_id, class_name: 'Request', dependent: :destroy

  def facebook_link
    linked_accounts.find_by(provider: 'facebook')&.link
  end

  def twitter_link
    linked_accounts.find_by(provider: 'twitter')&.link
  end
end
