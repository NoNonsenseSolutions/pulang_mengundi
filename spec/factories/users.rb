# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    name { FFaker::Name.name }
    ic { "#{20.years.ago.strftime('%y%m%d')}-#{random_digit(2)}-#{random_digit(4)}" }
    phone_area_code '60'      # hardcoding since phone validation is really strict
    phone_number '123456789'  # hardcoding since phone validation is really strict
    phone_verified_at { Date.yesterday }
    read_terms true

    trait :no_ic do
      ic nil
    end

    trait :no_email do
      email nil
    end

    trait :no_phone do
      phone_area_code nil
      phone_number nil
      phone_verified_at nil
    end

    trait :not_read_terms do
      read_terms false
    end

    trait :reindex do
      after(:create) do |product, _evaluator|
        product.reindex(refresh: true)
      end
    end
  end
end
