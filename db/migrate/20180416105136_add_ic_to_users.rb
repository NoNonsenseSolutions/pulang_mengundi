class AddIcToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :ic, :string
    add_index :users, :ic, unique: true
  end
end
