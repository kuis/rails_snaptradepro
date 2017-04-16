class AddArchivedToAppraisals < ActiveRecord::Migration
  def change
    add_column :appraisals, :archived, :boolean, default: false, null: false
  end
end
