class AddAdminAndOwnerToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :owner_id, :integer
    add_column :organizations, :admin_id, :integer
  end
end
