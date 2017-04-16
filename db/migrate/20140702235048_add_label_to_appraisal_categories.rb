class AddLabelToAppraisalCategories < ActiveRecord::Migration
  def change
    add_column :appraisal_categories, :label, :string
  end
end
