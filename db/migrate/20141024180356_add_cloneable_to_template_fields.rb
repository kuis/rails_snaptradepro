class AddCloneableToTemplateFields < ActiveRecord::Migration
  def change
    add_column :template_fields, :cloneable, :boolean, default: true, null: false
  end
end
