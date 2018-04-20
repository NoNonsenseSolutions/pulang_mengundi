class AddFlaggedToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :flagged, :boolean, default: false
  end
end
