class AddExtraDetailsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :unconfirmed_email, :string
    add_column :users, :email, :string
    add_column :users, :phone_number, :string
    add_column :users, :phone_area_code, :string
    
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :confirmed_at, :datetime

    add_column :users, :email_public, :boolean, default: false

    add_index :users, :confirmation_token,   unique: true
    add_index :users, :email, unique: true
  end
end
