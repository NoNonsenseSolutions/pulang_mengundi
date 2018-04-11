class AddProfilePicToLinkedAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :linked_accounts, :profile_pic, :string
  end
end
