# frozen_string_literal: true

require 'rails_helper'

describe Pledge do
  subject { build :pledge }

  it { should be_valid }

  context 'extra validations' do
    it 'cannot create with user having more than two pending pledges' do
      user = create(:user)
      create(:pledge, donor: user, status: 0)
      create(:pledge, donor: user, status: 0)
      pledge = build(:pledge, donor: user)
      expect(pledge.valid?).to be false
    end

    it 'verified user can create more than 2 pending pledges' do
      user = create(:user, verified_donor: true)
      create(:pledge, donor: user, status: 0)
      create(:pledge, donor: user, status: 0)
      pledge = build(:pledge, donor: user)
      expect(pledge.valid?).to be true
    end
  end
end
