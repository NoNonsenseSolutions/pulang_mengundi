class ChangePledgeStatus < ActiveRecord::Migration[5.2]
  def change
    rename_column :pledges, :donor_status, :status
    remove_column :pledges, :requester_status, :integer, default: 0
  end
end
