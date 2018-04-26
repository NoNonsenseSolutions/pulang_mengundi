class AddVerifiedDonorToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :verified_donor, :boolean, default: false
  end
end
