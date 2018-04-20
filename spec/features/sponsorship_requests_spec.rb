# frozen_string_literal: true

require 'rails_helper'

describe 'sponsorship requests', type: :feature do
  let(:name) { user.name }
  let(:email) { user.email }
  let(:auth_hash) { create(:auth_hash, :facebook, name: name, email: email) }

  before do
    login_omniauth(auth_hash)
    visit home_path(locale: :en)
    click_button 'SUBMIT MY REQUEST'
  end

  context 'user missing mandatory information' do
    let(:user) { create(:user) }

    it 'redirects to edit profile page' do
      expect(page).to have_content(I18n.t('requests.new.missing_ic'))
      expect(page.current_path).to eq(edit_profiles_path(locale: :en))
    end
  end



end
