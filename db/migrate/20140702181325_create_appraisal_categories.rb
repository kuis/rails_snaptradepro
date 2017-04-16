class CreateAppraisalCategories < ActiveRecord::Migration
  def change
    create_table :appraisal_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
