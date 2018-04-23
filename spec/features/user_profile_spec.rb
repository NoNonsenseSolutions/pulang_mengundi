# frozen_string_literal: true

require 'rails_helper'

describe 'User Profile Page', type: :feature, js: true do
  let(:ic_number) { "#{20.years.ago.strftime('%y%m%d')}-#{random_digit(2)}-#{random_digit(4)}" }
  let(:user) { create(:user) }
  let(:auth_hash) { create(:auth_hash, :facebook, name: user.name, email: user.email) }

  before do
    login_omniauth(auth_hash, user.name)
    visit profiles_path(locale: :en)
  end

  context 'newly logged in & created user' do
    let(:user) { create(:user, :no_ic, :no_phone, :no_email) }

    it 'shows IC field editable & working with or without dashes' do
      expect(page).to have_content(I18n.t('profiles.show.edit_email', locale: :en))
      expect(page).to have_content(I18n.t('profiles.show.verify_phone', locale: :en))
      expect(page).to have_content(I18n.t('profiles.show.add_ic_and_pic', locale: :en))
    end
  end
end
