class Appraisal < ActiveRecord::Base
  extend Enumerize

  extend FriendlyId
  friendly_id :number, use: [:slugged, :finders]

  acts_as_commentable

  STATUSES = [
    "Assessment",
    "Valuation",
    "Committed",
    "Rejected",
    "Reconditioning",
    "Rfs",
    "Sold",
    "Delivered"
  ]

  attr_accessor :skip_custom_field_validation

  enumerize :status, in: STATUSES,
                     scope: true,
                     predicates: { prefix: true },
                     default: :Assessment,
                     i18n_scope: "status"

  belongs_to :user
  belongs_to :customer
  belongs_to :organization
  belongs_to :appraisal_template
  has_many :appraisal_entries, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :discussions
  has_many :checklists
  has_one :valuation

  validates :user, presence: true
  validates :appraisal_template, presence: true
  validates :organization, presence: true
  validates :customer_id, presence: { message: 'Please select or create customer.' }
  validates :name, presence: { message: 'Please enter name.'}
  validate :template_available?
  validate :custom_fields_complete?

  accepts_nested_attributes_for :appraisal_entries

  scope :visible, -> { where(archived: false) }
  scope :archived, -> { where(archived: true) }

  def human_title
    "##{number} (#{appraisal_template.label})"
  end

  def field_value(field_id,is_capitalized=false)
    entry = field_entry(field_id)
    value = entry ? entry.get_value : ""
    field = TemplateField.find_by_id(field_id)
    field_formatting = TemplateField::CAPITALIZED[field.try(:formatting).to_s]
    if is_capitalized && field && value && field_formatting.present?
      value.send(field_formatting.to_sym)
    else
      value
    end
  end

  def field_readable_value(field_id)
    entry = field_entry(field_id)
    entry ? entry.readable_value : ""
  end

  def field_entry(field_id)
    # handle raw ID or record
    field_id = field_id.is_a?(TemplateField) ? field_id.id : field_id
    appraisal_entries.detect { |ae| ae.template_field_id == field_id }
  end

  def custom_fields=(fields_hash)
    return unless fields_hash
    fields_hash.each do |field_id, value|
      set_field_value(field_id, value)
    end
  end

  def set_field_value(field_id, value)
    field_id = field_id.to_i
    entry = field_entry(field_id)

    return unless entry || value.present?

    entry ||= appraisal_entries.build(template_field_id: field_id)
    entry.set_value(value)
  end

  def save_fields
    appraisal_entries.each { |entry| entry.save }
  end

  def self.clone(appraisal)
    cloned = appraisal.dup
    appraisal_entries = appraisal.appraisal_entries

    cloned.name = "Cloned - #{cloned.name}"
    cloned.unit = nil
    cloned.number = appraisal.organization.next_appraisal_number(increment: true)
    cloned.save!

    appraisal_entries.each do |entry|
      next if entry.template_field.cloneable == false ||
              entry.template_field.field_type == "Photo"
      cloned_entry = entry.dup
      cloned_entry.appraisal_id = cloned.id
      cloned_entry.save
    end
    cloned
  end

  def can_be_converted_to_ets
    available_ets = self.organization.is_equipment_type_enabled? ? self.organization.equipment_types : []
    self.appraisal_template.equipment_type.can_be_converted_to_ets.select{|et| available_ets.include?(et)}
  end

  private

  def template_fields
    if appraisal_template
      appraisal_template.visible_categories.map(&:template_fields).flatten
    else
      []
    end
  end

  def template_available?
    unless organization && organization.appraisal_templates.find_by(id: appraisal_template.id)
      errors.add(:appraisal_template, "not available")
    end
  end

  def custom_fields_complete?
    return if skip_custom_field_validation

    template_fields.each do |field|
      if field.required? && !field_entry(field.id).try(:value).try(:present?)
        errors.add(field.to_sym, "can't be blank")
      end
    end
  end
end
