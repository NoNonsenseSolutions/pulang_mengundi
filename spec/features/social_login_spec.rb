# frozen_string_literal: true

require 'rails_helper'

describe 'social login', type: :feature, js: true do
  before do
    OmniAuth.config.test_mode = true
    visit root_path(locale: :en)
  end

  [:facebook, :twitter].each do |provider|
    context provider do
      let(:name) { FFaker::Name.name }
      let(:email) { FFaker::Internet.safe_email }
      let(:auth_hash) { create(:auth_hash, provider, name: name, email: email) }

      before { OmniAuth.config.mock_auth[provider] = auth_hash }

      it 'logs in and creates user & linked accounts' do
        page.find(".login-box .social-media-icons.#{provider}").click
        expect(page).to have_content("Signed in as #{name}")
        expect(page.current_path).to eq(root_path(locale: :en))

        user = User.find_by(email: email)
        expect(user).to_not be_nil

        linked_account = LinkedAccount.find_by(uid: auth_hash.uid, email: email)
        expect(linked_account).to_not be_nil
      end
    end
  end
end
