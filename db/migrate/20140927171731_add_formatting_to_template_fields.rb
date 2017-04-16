class AddFormattingToTemplateFields < ActiveRecord::Migration
  def change
    add_column :template_fields, :formatting, :text
  end
end
