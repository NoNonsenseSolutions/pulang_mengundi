class AddRemainingBalanceToRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :requests, :remaining_balance, :decimal, precision: 8, decimal: 2
  end
end
