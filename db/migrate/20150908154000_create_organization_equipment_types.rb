class CreateOrganizationEquipmentTypes < ActiveRecord::Migration
  def change
    create_table :organization_equipment_types do |t|
      t.integer :organization_id
      t.integer :equipment_type_id

      t.timestamps
    end
  end
end
