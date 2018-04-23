class CreatePhoneVerifications < ActiveRecord::Migration[5.2]
  def change
    create_table :phone_verifications do |t|
      t.string :phone_area_code
      t.string :phone_subscriber_number
      t.datetime :last_sent_at
      t.references :user, foreign_key: true
      t.integer :number_of_times_sent, default: 0
      t.string :verification_code

      t.timestamps
    end
  end
end
