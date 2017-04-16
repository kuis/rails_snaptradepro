class CreateAppraisalColumnTemplateFields < ActiveRecord::Migration
  def change
    create_table :appraisal_column_template_fields do |t|
      t.integer :appraisal_column_id
      t.integer :template_field_id

      t.timestamps
    end
    add_index :appraisal_column_template_fields, [:appraisal_column_id, :template_field_id], name: "index_appraisal_column_template_field"
    remove_column :appraisal_columns, :template_field_id, :integer
    rename_column :appraisal_columns, :static_field, :static_fields
  end
end
