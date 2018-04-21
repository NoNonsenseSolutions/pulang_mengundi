class AddNameToLinkedAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :linked_accounts, :name, :string
  end
end
