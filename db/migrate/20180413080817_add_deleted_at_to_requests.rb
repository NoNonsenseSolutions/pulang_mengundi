class AddDeletedAtToRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :requests, :disabled_at, :datetime
    add_index :requests, :disabled_at
  end
end
