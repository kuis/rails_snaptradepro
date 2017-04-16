class AddWeightToTemplateFields < ActiveRecord::Migration
  def change
    add_column :template_fields, :weight, :integer, null: false, default: 50
    change_column_default :template_fields, :weight, nil
  end
end
