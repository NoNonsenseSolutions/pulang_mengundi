# frozen_string_literal: true

module OmniAuth
  def mock_omniauth(opts = {})
    default = { provider: :facebook,
                uuid: '1234',
                facebook: {
                  email: 'foobar@example.com',
                  gender: 'Male',
                  first_name: 'foo',
                  last_name: 'bar'
                } }

    credentials = default.merge(opts)
    provider = credentials[:provider]
    user_hash = credentials[provider]

    OmniAuth.config.test_mode = true

    OmniAuth.config.mock_auth[provider] = {
      'uid' => credentials[:uuid],
      'extra' => {
        'user_hash' => {
          'email' => user_hash[:email],
          'first_name' => user_hash[:first_name],
          'last_name' => user_hash[:last_name],
          'gender' => user_hash[:gender]
        }
      }
    }
  end

  def mock_invalid_omniauth(opts = {})
    credentials = { provider: :facebook,
                    invalid: :invalid_crendentials }.merge(opts)

    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[credentials[:provider]] = credentials[:invalid]
  end

  def login_omniauth(auth_hash, name)
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[auth_hash.provider.to_sym] = auth_hash
    visit root_path(locale: :en)
    page.find(".login-box .social-media-icons.#{auth_hash.provider}").click
    expect(page).to have_content("Signed in as #{name}")
    expect(page.current_path).to eq(root_path(locale: :en))
  end
end

RSpec.configure do |config|
  config.include OmniAuth, type: :feature
end
