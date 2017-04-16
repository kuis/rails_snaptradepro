class AddDeletedAtToAppraisalEntries < ActiveRecord::Migration
  def change
    add_column :appraisal_entries, :deleted_at, :datetime
    add_index :appraisal_entries, :deleted_at
  end
end
