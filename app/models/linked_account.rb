class LinkedAccount < ApplicationRecord
  belongs_to :user

  def self.create_with_omniauth(auth)
  
    linked_account = find_or_create_by(uid: auth['uid'], provider:  auth['provider'])
  end
end
