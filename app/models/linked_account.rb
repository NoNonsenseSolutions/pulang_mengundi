# frozen_string_literal: true

class LinkedAccount < ApplicationRecord
  belongs_to :user

  class UserOverwrittenError < StandardError
  end

  def self.create_with_omniauth(auth, current_user)
    linked_account = find_or_initialize_by(uid: auth['uid'], provider: auth['provider'])

    auth_info = extract_info(auth)

    linked_account.link = auth_info[:link] unless linked_account.link
    linked_account.profile_pic = auth_info[:profile_pic] unless linked_account.profile_pic
    linked_account.email = auth_info[:email] unless linked_account.email

    if linked_account.user
      # if there's already a user to this account(previously persisted)
      # if it's not, it means that linked account is tied to another user, throw erro
      raise UserOverwrittenError if current_user && current_user != linked_account.user

      # if there's no current user, log in linked account user
    else
      # new linked account
      linked_account.user = if current_user
                              # assign current user
                              current_user
                            else
                              user = User.find_by(email: auth_info[:email]) if auth_info[:email].present?
                              if user
                                # linked in sometimes returns email as an emptry string, presumably because users signed up with phone
                                user
                              else
                                # if there's no existing user, Create a user
                                User.create!(name: auth_info[:name],
                                             profile_pic: auth_info[:profile_pic],
                                             email: auth_info[:email])
                              end
                            end

    end

    linked_account.save
    linked_account.user
  end

  class << self
    private

    def extract_info(auth)
      if auth['provider'] == 'facebook'
        facebook_details(auth)
      elsif auth['provider'] == 'twitter'
        twitter_details(auth)
      else
        raise 'not implemented'
      end
    end

    def facebook_details(auth)
      {
        link: auth.dig('extra', 'raw_info', 'link'),
        profile_pic: auth.dig('info', 'image'),
        name: auth.dig('extra', 'raw_info', 'name'),
        email: auth.dig('info', 'email')
      }
    end

    def twitter_details(auth)
      email = auth.dig('info', 'email')
      {
        link: auth.dig('info', 'urls', 'Twitter'),
        profile_pic: auth.dig('info', 'image'),
        name: auth.dig('info', 'name'),
        email: email.present? ? email : nil
      }
    end
  end
end
