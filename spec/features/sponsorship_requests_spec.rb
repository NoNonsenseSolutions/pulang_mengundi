# frozen_string_literal: true

require 'rails_helper'

describe 'sponsorship requests', type: :feature do
  let(:user) { create(:user) }
  let(:auth_hash) { create(:auth_hash, :facebook, name: user.name, email: user.email) }

  before do
    login_omniauth(auth_hash, user.name)
    visit home_path(locale: :en)
    click_button 'SUBMIT MY REQUEST'
  end

  context 'user missing mandatory information' do
    let(:user) { create(:user, :no_ic) }

    it 'redirects to edit profile page' do
      expect(page).to have_content(I18n.t('requests.new.missing_ic'))
      expect(page.current_path).to eq(edit_profiles_path(locale: :en))
    end
  end

  context 'terms not accepted' do
    let(:user) { create(:user, :not_read_terms) }

    it 'redirects to terms & conditions page page' do
      expect(page).to have_content(I18n.t('requests.form.acknowledge'))
      expect(page.current_path).to eq(terms_and_conditions_path(locale: :en))
    end
  end

end
