class AddArchivedToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :archived, :boolean, default: false, null: false
  end
end
