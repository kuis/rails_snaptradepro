class AddStaticFieldToAppraisalColumn < ActiveRecord::Migration
  def change
    add_column :appraisal_columns, :static_field, :string
  end
end
