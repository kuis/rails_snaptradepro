class AddUserCreatableToOrganizationEquipmentTypes < ActiveRecord::Migration
  def change
    add_column :organization_equipment_types, :user_creatable, :boolean, default: true
  end
end
