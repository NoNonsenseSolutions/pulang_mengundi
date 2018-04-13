class AddConfirmedAtToPledge < ActiveRecord::Migration[5.2]
  def change
    add_column :pledges, :confirmed_at, :datetime
  end
end
