class AddAgentToTemplates < ActiveRecord::Migration
  def change
    add_column :appraisal_templates, :agent, :boolean, default: false, null: false
  end
end
