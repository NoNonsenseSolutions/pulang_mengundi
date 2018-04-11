class CreateLinkedAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :linked_accounts do |t|
      t.string :provider
      t.string :uid
      t.string :link
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
