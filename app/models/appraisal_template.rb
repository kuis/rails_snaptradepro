class AppraisalTemplate < ActiveRecord::Base
  has_and_belongs_to_many :appraisal_categories
  has_and_belongs_to_many :organizations
  has_many :print_templates
  belongs_to :equipment_type

  validates :label, presence: true
  validates :name, presence: true, uniqueness: true

  before_create :set_default_equipment_type

  scope :with_equipment_type, lambda{ |equipment_type| where(equipment_type_id: equipment_type.id) }

  def visible_categories
    appraisal_categories.joins(:template_fields).uniq
  end

  def self.clone(template)
    cloned = template.dup
    cloned.name = "Cloned - #{cloned.name} #{AppraisalTemplate.count}"
    cloned.save!

    # clone appraisal categories
    template.appraisal_categories.each do |category|
      cloned.appraisal_categories << category
    end

    cloned
  end

  private

  def set_default_equipment_type
    self.equipment_type = self.equipment_type || EquipmentType.find_or_create_by(name: "TA") do |et|
      et.label = "Trade Appraisal"
    end
  end
end
