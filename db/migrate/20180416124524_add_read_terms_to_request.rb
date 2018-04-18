class AddReadTermsToRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :requests, :read_terms, :boolean, default: false
  end
end
