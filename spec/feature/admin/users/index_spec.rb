require 'rails_helper'

describe 'users', type: :feature do
  let(:admin) { create(:admin) }
  let!(:user) { create(:user) }

  before do
    login_as(admin)
    visit('administrator/users')
  end

  scenario 'view users' do
    expect(page).to have_content(user.name)
  end
end
