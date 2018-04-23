class CreateBuses < ActiveRecord::Migration[5.2]
  def change
    create_table :buses do |t|
      t.string :date
      t.string :time
      t.string :depart_city
      t.string :arrive_city
      t.string :link
      t.string :image_link
      t.string :seat

      t.timestamps
    end
  end
end
