class AddColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :ic_verified_at, :datetime
  end
end
