class RemoveBelongsToFromTemplateFields < ActiveRecord::Migration
  def change
    remove_column :template_fields, :appraisal_category_id
  end
end
