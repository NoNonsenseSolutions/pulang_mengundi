class RemoveReadTermsFromRequestAndMoveToUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :requests, :read_terms, :boolean
    add_column :users, :read_terms, :boolean, default: false
  end
end
