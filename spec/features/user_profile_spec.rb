# frozen_string_literal: true

require 'rails_helper'

describe 'User Profile Page', type: :feature, js: true do
  let(:ic_number) { "#{20.years.ago.strftime('%y%m%d')}-#{random_digit(2)}-#{random_digit(4)}" }
  let(:user) { create(:user) }
  let(:auth_hash) { create(:auth_hash, :facebook, name: user.name, email: user.email) }

  before do
    login_omniauth(auth_hash, user.name)
    visit edit_profiles_path(locale: :en)
  end

  it 'shows current user information' do
    within('form.simple_form') do
      expect(find_field('user[email]').value).to eq(user.email)
      expect(find_field('user[ic]', disabled: true).value).to eq(user.ic)
      expect(find_field('user[phone_area_code]', visible: false).value).to eq(user.phone_area_code)
      expect(find_field('user[phone_number]').value).to eq(user.phone_number)
    end
  end

  context 'newly logged in & created user' do
    let(:user) { create(:user, :no_ic) }

    it 'shows IC field editable & working with or without dashes' do
      expect(user.ic).to be_nil

      within('form.simple_form') do
        expect(find_field('user[email]').value).to eq(user.email)
        expect(find_field('user[ic]').value).to eq('')

        fill_in 'user[ic]', with: ic_number.gsub('-','')
        expect(find_field('user[ic]').value).to eq(ic_number)

        fill_in 'user[ic]', with: ''
        expect(find_field('user[ic]').value).to eq('')

        fill_in 'user[ic]', with: ic_number
        expect(find_field('user[ic]').value).to eq(ic_number)

        click_on 'Save'
      end

      expect(page).to have_content('Profile updated!')
      user.reload
      expect(user.ic).to eq(ic_number)
    end
  end
end