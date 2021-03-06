# frozen_string_literal: true

# == Schema Information
#
# Table name: linked_accounts
#
#  id          :integer          not null, primary key
#  provider    :string
#  uid         :string
#  link        :string
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  profile_pic :string
#  email       :string
#

class LinkedAccount < ApplicationRecord
  belongs_to :user

  class UserOverwrittenError < StandardError
  end

  class << self
    def sync_facebook_linked_account_name
      @oauth = Koala::Facebook::OAuth.new(ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'], 'https://localhost:3000/auth/facebook/callback')
      access_token = @oauth.get_app_access_token
      @graph = Koala::Facebook::API.new(access_token)
      where(provider: 'facebook').find_each do |la|
        user_object = @graph.get_object(la.uid)
        la.name = user_object['name']
        la.save
      end
    end

    def create_with_omniauth(auth, current_user)
      linked_account = find_or_initialize_by(uid: auth['uid'], provider: auth['provider'])

      auth_info = extract_info(auth)

      linked_account.link = auth_info[:link] unless linked_account.link
      linked_account.profile_pic = auth_info[:profile_pic] unless linked_account.profile_pic
      linked_account.email = auth_info[:email] unless linked_account.email
      linked_account.name = auth_info[:name] unless linked_account.name

      if linked_account.user
        # if there's already a user to this account(previously persisted)
        # if it's not, it means that linked account is tied to another user, throw erro
        raise UserOverwrittenError if current_user && current_user != linked_account.user
      else
        # new linked account
        linked_account.user = if current_user
                                # assign current user
                                current_user

                              else
                                linked_account.user = if auth_info[:email].present? && (user = User.find_by(email: auth_info[:email]))
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

  def search_link
    return nil unless provider == 'facebook' && name.present?
    "https://www.facebook.com/search/people/?q=#{CGI.escape(name)}"
  end
end
