class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.references :reporter, references: :users
      t.references :reported, references: :users
      t.text :reason

      t.timestamps
    end

    add_index :reports, [:reporter_id, :reported_id], unique: true
  end
end
