class AddWarrantyToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :warranty, :text
  end
end
