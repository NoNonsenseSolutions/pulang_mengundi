class CreatePledges < ActiveRecord::Migration[5.2]
  def change
    create_table :pledges do |t|
      t.decimal :amount, precision: 8, scale: 2
      t.references :donor, references: :users
      t.integer :donor_status, default: 0
      t.integer :requester_status, default: 0
      t.references :request, foreign_key: true

      t.timestamps
    end
  end
end
