class AddReadTermsToPledges < ActiveRecord::Migration[5.2]
  def change
    add_column :pledges, :read_terms, :boolean, default: false
  end
end
