# frozen_string_literal: true

FactoryBot.define do
  factory :request do
    requester { build(:user) }
    bank_name { Bank::NAMES.sample }
    account_name { FFaker::Lorem.word }
    account_number { rand(100_000_000...999_999_999) }
    transport_type { Request::TRANSPORT_TYPES.sample }
    travelling_fees { 100 }
    target_amount { 30 }
    remaining_balance { target_amount }
    to_state { ElectoralDistrict::STATES.sample }
  end
end
