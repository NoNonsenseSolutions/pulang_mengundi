# frozen_string_literal: true

include ActionDispatch::TestProcess

FactoryBot.define do
  factory :request do
    requester { build(:user) }
    bank_name { Bank::NAMES.sample }
    account_name { FFaker::Lorem.word }
    account_number { rand(100_000_000...999_999_999) }
    transport_type { Request::TRANSPORT_TYPES.sample }
    travelling_fees { 100 }
    target_amount { 30 }
    to_state { ElectoralDistrict::STATES.sample }

    trait :with_documents do
      supporting_documents { [fixture_file_upload(Rails.root.join('spec', 'photos', 'test.jpg'), 'image/jpg')] }
    end
  end
end
