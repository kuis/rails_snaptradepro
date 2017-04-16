class EquipmentType < ActiveRecord::Base
  has_many :appraisal_templates
  has_many :organizations, through: :organization_equipment_types
  has_many :organization_equipment_types

  serialize :can_be_converted_to_ids, Array
  validates :name, uniqueness: true

  scope :all_without_et, lambda{ |et| where("id <> ?",et.id)}

  def name_with_label
    "#{self.name} - #{self.label}"
  end

  def can_be_converted_to_ets
    self.can_be_converted_to_ids.collect{|et_id| EquipmentType.find(et_id)}
  end

  def appraisal_templates_of(organization)
    organisation_related_appraisal_template_ids = organization.appraisal_templates_organizations.where("appraisal_templates_organizations.is_visible=?",true).map(&:appraisal_template_id)
    self.appraisal_templates.where("appraisal_templates.id IN (?)", organisation_related_appraisal_template_ids)
  end


end
