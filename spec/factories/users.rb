# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    name { FFaker::Name.name }
    read_terms { true }
  end
end
