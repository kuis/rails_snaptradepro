class AddCompletedOnDateToChecklistItems < ActiveRecord::Migration
  def change
    add_column :checklist_items, :completed_at, :datetime
    add_index :checklist_items, :completed_at
  end
end
