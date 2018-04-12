class ChangeColumnsInRequest < ActiveRecord::Migration[5.2]
  def change
    remove_column :requests, :from_city, :string
    remove_column :requests, :from_state, :string
    add_column :requests, :itinerary, :text
    add_column :requests, :travel_company, :string
  end
end
