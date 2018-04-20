# frozen_string_literal: true

require 'rails_helper'

feature 'pledges index' do
  background do
    mock_omniauth
    visit pledges_path(locale: :en)
  end

  scenario 'User able to view existing pledges' do
  end
end
