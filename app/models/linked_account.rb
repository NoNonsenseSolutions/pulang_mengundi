class LinkedAccount < ApplicationRecord
  belongs_to :user

  def self.create_with_omniauth(auth, current_user)
    linked_account = find_or_create_by(uid: auth['uid'], provider:  auth['provider'])
    auth_info = extract_info(auth)

    linked_account.link = auth_info[:link] unless linked_account.link
    linked_account.profile_pic = auth_info[:profile_pic] unless linked_account.profile_pic
    
    if current_user
      # link account to user if logged in
      linked_account.user = user
      linked_account.save
    else
      if user = linked_account.user
        # return user if already present
        user
      else
        # create and return user if new linked account
        user = User.create(name: auth_info[:name], profile_pic: auth_info[:profile_pic])
        linked_account.user = user
        linked_account.save
        user
      end
    end
  end

  private
    def self.extract_info(auth)
      if auth['provider'] == "facebook"
        facebook_details(auth)
      elsif auth['provider'] == "twitter"
        facebook_details(auth)
      else
        raise "not implemented"
      end
    end

    def self.facebook_details(auth)
      {
        link: auth.dig('extra', 'raw_info', 'link'),
        profile_pic: auth.dig('info', 'image'),
        name: auth.dig('extra', 'raw_info', 'name')
      }
    end

    def self.twitter_details(auth)
      {
        link: auth.dig('info', 'urls', 'Twitter'),
        profile_pic: auth.dig('info', 'image'),
        name: auth.dig('info', 'name')
      }
    end
end
