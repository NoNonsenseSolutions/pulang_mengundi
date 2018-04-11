class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :hashed_phone
      t.datetime :phone_verified_at
      t.string :name

      t.timestamps
    end
  end
end
