# frozen_string_literal: true

require 'rails_helper'

describe Admin do
  subject { build :admin }

  it { should be_valid }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should validate_presence_of(:password) }
end
