class CreateRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :requests do |t|
      t.string :bank_name
      t.string :account_number
      t.string :account_name
      t.text :description
      t.string :transport_type
      t.string :from_city
      t.string :from_state
      t.string :to_city
      t.string :to_state
      t.decimal :travelling_fees, default: 0, precision: 8, scale: 2
      t.decimal :target_amount, default: 0, precision: 8, scale: 2
      t.references :requester, references: :users

      t.timestamps
    end
  end
end
