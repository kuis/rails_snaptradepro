class AddRolesToFieldAccessControl < ActiveRecord::Migration
  def change
    change_column :field_access_controls, :view_permission, :string
    change_column :field_access_controls, :edit_permission, :string
  end
end
