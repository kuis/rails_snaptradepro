class AddAppraisalTemplateIdToPrintTemplates < ActiveRecord::Migration
  def change
    add_column :print_templates, :appraisal_template_id, :integer
    add_column :print_templates, :layout_type, :string
  end
end
