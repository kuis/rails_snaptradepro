class CreateAppraisalColumns < ActiveRecord::Migration
  def change
    create_table :appraisal_columns do |t|
      t.string :column_name
      t.integer :template_field_id

      t.timestamps
    end
  end
end
