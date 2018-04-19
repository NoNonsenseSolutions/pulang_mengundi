# frozen_string_literal: true

require 'rails_helper'

describe User do
  subject { build :user }

  context '#phone' do
    it 'should have area code and number' do
      subject.phone_area_code = '+1'
      subject.phone_number = '217-819-6984'

      expect(subject.phone).to eq('+1217-819-6984')
    end

    it 'should works even if phone_area_code is nil' do
      subject.phone_number = '217-819-6984'

      expect(subject.phone).to eq('217-819-6984')
    end

    it 'should works even if phone_number is nil' do
      subject.phone_area_code = '+1'

      expect(subject.phone).to eq('+1')
    end
  end
end
