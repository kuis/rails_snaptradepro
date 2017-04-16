class CreateAppraisalCategoriesTemplateFields < ActiveRecord::Migration
  def change
    create_table :appraisal_categories_template_fields do |t|
      t.integer :appraisal_category_id
      t.integer :template_field_id
    end

    remove_column :template_fields, :appraisal_template_id, :integer
  end
end
