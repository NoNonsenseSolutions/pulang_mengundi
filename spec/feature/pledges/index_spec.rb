require 'rails_helper'

feature 'pledges index' do
  background do
    set_omniauth
    visit pledges_path(locale: :en)
  end

  xscenario 'User able to view existing pledges' do
  end
end