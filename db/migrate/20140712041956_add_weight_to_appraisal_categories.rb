class AddWeightToAppraisalCategories < ActiveRecord::Migration
  def change
    add_column :appraisal_categories, :weight, :integer, null: false, default: 50
  end
end
