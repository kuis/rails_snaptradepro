class AddCanBeConvertedToIdsToEquipmentTypes < ActiveRecord::Migration
  def change
    add_column :equipment_types, :can_be_converted_to_ids, :string
  end
end
