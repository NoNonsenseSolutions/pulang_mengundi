class ChangePhoneNumberColumnsFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :hashed_phone, :string
  end
end
