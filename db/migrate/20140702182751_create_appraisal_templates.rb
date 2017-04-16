class CreateAppraisalTemplates < ActiveRecord::Migration
  def change
    create_table :appraisal_templates do |t|
      t.string :name

      t.timestamps
    end
  end
end
