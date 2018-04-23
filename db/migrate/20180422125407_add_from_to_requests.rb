class AddFromToRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :requests, :from_country, :string
    add_column :requests, :from_state, :string
    add_column :requests, :from_city, :string
    add_column :requests, :from_details, :string
  end
end
