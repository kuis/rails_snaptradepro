class AddEquipmentTypeIdToAppraisalTemplates < ActiveRecord::Migration
  def change
    add_column :appraisal_templates, :equipment_type_id, :integer
  end
end
