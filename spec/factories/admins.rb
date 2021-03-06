# frozen_string_literal: true

FactoryBot.define do
  factory :admin do
    email { FFaker::Internet.email }
    password { 'password' }
    name { FFaker::Name.name }
  end
end
