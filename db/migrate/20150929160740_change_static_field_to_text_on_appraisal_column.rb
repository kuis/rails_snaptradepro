class ChangeStaticFieldToTextOnAppraisalColumn < ActiveRecord::Migration
  def change
    change_column :appraisal_columns, :static_fields, :text
  end
end
