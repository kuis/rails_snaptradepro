class CreateAppraisalCategoriesTemplates < ActiveRecord::Migration
  def change
    create_table :appraisal_categories_templates do |t|
      t.integer :appraisal_category_id
      t.integer :appraisal_template_id
    end
  end
end
