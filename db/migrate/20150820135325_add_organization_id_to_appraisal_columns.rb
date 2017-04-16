class AddOrganizationIdToAppraisalColumns < ActiveRecord::Migration
  def change
    add_column :appraisal_columns, :organization_id, :integer
  end
end
