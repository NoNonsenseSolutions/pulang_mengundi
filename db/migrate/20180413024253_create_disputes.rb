class CreateDisputes < ActiveRecord::Migration[5.2]
  def change
    create_table :disputes do |t|
      t.text :comment
      t.references :pledge, foreign_key: true
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
