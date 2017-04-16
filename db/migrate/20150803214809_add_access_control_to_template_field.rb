class AddAccessControlToTemplateField < ActiveRecord::Migration
  def change
    add_column :template_fields, :has_access_control, :boolean
  end
end
