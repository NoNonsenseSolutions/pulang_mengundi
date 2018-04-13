class AddTotalReceivedToRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :requests, :total_received, :decimal, precision: 8, scale: 3, default: 0
  end
end
