class AddEmailToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :linked_accounts, :email, :string
  end
end
