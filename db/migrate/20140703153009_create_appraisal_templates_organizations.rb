class CreateAppraisalTemplatesOrganizations < ActiveRecord::Migration
  def change
    create_table :appraisal_templates_organizations do |t|
      t.integer :organization_id
      t.integer :appraisal_template_id
    end
  end
end
