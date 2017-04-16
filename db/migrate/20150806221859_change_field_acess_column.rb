class ChangeFieldAcessColumn < ActiveRecord::Migration
  def change
    rename_column :field_access_controls, :view, :view_permission
    rename_column :field_access_controls, :edit, :edit_permission
  end
end
