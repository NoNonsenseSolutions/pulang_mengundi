require 'rails_helper'

describe 'admins', type: :feature do
  let(:admin) { create(:admin) }

  before do
    login_as(admin)
    visit('administrator/admins')
  end

  scenario 'create new admin' do
    expect_any_instance_of(Admin).to receive(:send_reset_password_instructions)

    click_on 'New admin'
    fill_in 'Name', with: 'John'
    fill_in 'Email', with: 'john@pulangmengundi.com'
    click_on 'Create admin'

    new_admin = Admin.last

    expect(new_admin.name).to eq('John')
    expect(new_admin.email).to eq('john@pulangmengundi.com')

    expect(page).to have_content('Admin created')
  end

  scenario 'missing fields' do
    expect_any_instance_of(Admin).to_not receive(:send_reset_password_instructions)

    click_on 'New admin'
    fill_in 'Name', with: 'John'
    click_on 'Create admin'

    expect(page).to have_content("Email can't be blank")
  end
end
