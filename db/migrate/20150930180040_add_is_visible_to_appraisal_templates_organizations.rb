class AddIsVisibleToAppraisalTemplatesOrganizations < ActiveRecord::Migration
  def change
    add_column :appraisal_templates_organizations, :is_visible, :boolean, default: true
  end
end
