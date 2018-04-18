require 'rails_helper'

describe 'admins', type: :feature do
  let(:admin) { create(:admin) }

  before do
    login_as(admin)
    visit('administrator/admins')
  end

  scenario 'view admins' do
    expect(page).to have_content(admin.name)
  end
end
