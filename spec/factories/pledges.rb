# frozen_string_literal: true

FactoryBot.define do
  factory :pledge do
    request { build(:request) }
    amount { rand(1...request.target_amount) }
    donor { build(:user) }
  end
end
