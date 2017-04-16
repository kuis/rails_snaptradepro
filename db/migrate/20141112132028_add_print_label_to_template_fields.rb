class AddPrintLabelToTemplateFields < ActiveRecord::Migration
  def change
    add_column :template_fields, :print_label, :string
  end
end
