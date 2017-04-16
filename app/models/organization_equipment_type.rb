class OrganizationEquipmentType < ActiveRecord::Base
  belongs_to :organization
  belongs_to :equipment_type
end
