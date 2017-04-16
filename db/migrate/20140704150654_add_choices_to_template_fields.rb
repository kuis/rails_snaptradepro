class AddChoicesToTemplateFields < ActiveRecord::Migration
  def change
    add_column :template_fields, :choices, :text
  end
end
