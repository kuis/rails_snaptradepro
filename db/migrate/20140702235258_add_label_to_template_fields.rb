class AddLabelToTemplateFields < ActiveRecord::Migration
  def change
    add_column :template_fields, :label, :string
  end
end
