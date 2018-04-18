FactoryBot.define do
    factory :auth_hash, class: OmniAuth::AuthHash do
      transient do
        email FFaker::Internet.safe_email
        avatar FFaker::Avatar.image
        name FFaker::Name.name
        user_name FFaker::Internet.user_name
      end

      initialize_with do
        OmniAuth::AuthHash.new({
          provider: provider,
          uid: uid,
          info: {
            image: avatar,
            email: email
          }.merge(info),
          extra: extra
        })
      end

      trait :facebook do
        provider "facebook"
        uid FFaker::Guid.guid
        info { {} }
        extra do
          {
            raw_info: {
              name: name,
              link: "https://www.facebook.com/#{user_name}"
            }
          }
        end
      end

      trait :twitter do
        provider "twitter"
        uid FFaker::Guid.guid
        info do
          {
            name: name,
            urls: {
              Twitter: "https://twitter.com/#{user_name}"
            }
          }
        end
        extra { {} }
      end
    end
  end