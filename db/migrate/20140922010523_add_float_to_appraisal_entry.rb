class AddFloatToAppraisalEntry < ActiveRecord::Migration
  def change
    add_column :appraisal_entries, :numeric, :float
  end
end
