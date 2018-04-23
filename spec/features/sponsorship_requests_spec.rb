# frozen_string_literal: true

require 'rails_helper'

describe 'sponsorship requests', type: :feature, js: true do
  let(:user) { create(:user) }
  let(:auth_hash) { create(:auth_hash, :facebook, name: user.name, email: user.email) }

  before do
    login_omniauth(auth_hash, user.name)
    visit home_path(locale: :en)
    click_button 'SUBMIT MY REQUEST'
  end

  context 'user missing email' do
    let(:user) { create(:user, :no_email) }
    it 'redirects to edit email profile page' do
      expect(page).to have_content(I18n.t('profiles.emails.edit.email_public_label'))
      expect(page.current_path).to eq(edit_profiles_emails_path(locale: :en))
    end
  end

  context 'user missing ic' do
    let(:user) { create(:user, :no_ic) }
    it 'redirects to edit ic profile page' do
      expect(page).to have_content(I18n.t('profiles.ic_details.edit.include_dash_in_ic'))
      expect(page.current_path).to eq(edit_profiles_ic_details_path(locale: :en))
    end
  end

  context 'terms not accepted' do
    let(:user) { create(:user, :not_read_terms) }

    it 'redirects to terms & conditions page page' do
      expect(page).to have_content(I18n.t('requests.form.acknowledge'))
      expect(page.current_path).to eq(terms_and_conditions_path(locale: :en))
    end
  end

  context 'form' do
    it 'shows reminder' do
      expect(page).to have_content(I18n.t('requests.new.reminder'))
    end

    context 'after reminder' do
      let(:transport_type) { Request::TRANSPORT_TYPES.sample }
      let(:travel_company) { FFaker::Company.name }
      let(:itinerary) { FFaker::HipsterIpsum.sentence }
      let(:to_state) { ElectoralDistrict::STATES.sample }
      let(:to_city) { ElectoralDistrict::PARLIAMENTARY_CONSTITUENCIES[to_state].sample }
      let(:description) { FFaker::HipsterIpsum.sentences.join(' ') }
      let(:travelling_fees) { rand(10**3).to_f }
      let(:target_amount) { (travelling_fees * 0.6).round(2) }
      let(:bank_name) { Bank::NAMES.sample }
      let(:account_number) { random_digit(12) }
      let(:account_name) { user.name }
      let(:supporting_documents) { 'sample-receipt.jpg' }

      before { page.find('#one-request-modal button.close').click }

      it 'shows all form fields' do
        within('form.new_request') do
          expect(page).to have_css('select[name="request[transport_type]"]', visible: false)
          expect(page).to have_css('input[name="request[travel_company]"]')
          expect(page).to have_css('textarea[name="request[itinerary]"]')
          expect(page).to have_css('select[name="request[to_state]"]', visible: false)
          expect(page).to have_css('select[name="request[to_city]"]', visible: false)
          expect(page).to have_css('textarea[name="request[description]"]')
          expect(page).to have_css('input[name="request[travelling_fees]"]')
          expect(page).to have_css('input[name="request[target_amount]"]')
          expect(page).to have_css('select[name="request[bank_name]"]', visible: false)
          expect(page).to have_css('input[name="request[account_number]"]')
          expect(page).to have_css('input[name="request[account_name]"]')
          expect(page).to have_css('input[name="request[supporting_documents][]"]', visible: false)
        end
      end

      it 'submits and creates requests' do
        within('form.new_request') do
          page.find('button[data-id=request_transport_type]').click
          page.find('ul.dropdown-menu li a', text: transport_type).click

          fill_in 'Travel Company', with: travel_company
          fill_in 'Intinerary / Receipt No.', with: itinerary

          page.find('button[data-id=request_to_state]').click
          page.find('ul.dropdown-menu li a', text: to_state).click

          select to_city, from: 'Constituency'

          fill_in 'Tell Us Why', with: description
          fill_in 'Total ticket amount (RM)', with: travelling_fees
          fill_in 'Sponsorship Requests', with: target_amount

          page.find('button[data-id=request_bank_name]').click
          page.find('ul.dropdown-menu li a', text: bank_name).click

          fill_in 'Account number', with: account_number
          fill_in 'Account name', with: account_name

          attach_file 'Choose File', Rails.root + file_fixture(supporting_documents), visible: false

          click_on 'Submit'
        end

        expect(page).to have_content(I18n.t('requests.create.success'))

        user.reload
        expect(user.request).to_not be_nil

        request = user.request
        expect(request.transport_type).to eq(transport_type)
        expect(request.travel_company).to eq(travel_company)
        expect(request.itinerary).to eq(itinerary)
        expect(request.to_state).to eq(to_state)
        expect(request.to_city).to eq(to_city)
        expect(request.description).to eq(description)
        expect(request.travelling_fees.to_s).to eq(travelling_fees.to_s)
        expect(request.target_amount.to_s).to eq(target_amount.to_s)
        expect(request.bank_name).to eq(bank_name)
        expect(request.account_number).to eq(account_number)
        expect(request.account_name).to eq(account_name)
        expect(request.supporting_documents.attached?).to eq(true)
        expect(request.supporting_documents.attachments.first.blob.filename).to eq(supporting_documents)
      end
    end
  end
end
