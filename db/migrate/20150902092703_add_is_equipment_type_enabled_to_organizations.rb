class AddIsEquipmentTypeEnabledToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :is_equipment_type_enabled, :boolean, defalut: false
  end
end
