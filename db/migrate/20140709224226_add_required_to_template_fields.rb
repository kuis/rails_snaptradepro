class AddRequiredToTemplateFields < ActiveRecord::Migration
  def change
    add_column :template_fields, :required, :boolean, default: false, null: false
  end
end
