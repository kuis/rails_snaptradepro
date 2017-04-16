class TemplateField < ActiveRecord::Base
  FIELD_TYPES = ["Text Field", "Text Area", "Photo", "Select",
                 "Check Boxes", "Numeric", "Date Field", "DateTime Field"]
  TYPES_WITH_CHOICES = ["Select", "Check Boxes"]
  TYPES_WITH_FORMATTING = ["Numeric", "Text Field"]
  CAPITALIZED = {"capitalization: first-letter" => :capitalize, "capitalization: first-letter-all-words" => :titleize, "capitalization: all-words" => :upcase}

  has_and_belongs_to_many :appraisal_categories
  has_many :field_access_control

  has_many :appraisal_column_template_fields, dependent: :destroy
  has_many :appraisal_columns, through: :appraisal_column_template_fields

  validates :name, presence: true, uniqueness: true
  validates :label, presence: true
  validates :field_type, presence: true
  validates :weight, presence: true, numericality: true, inclusion: 0..100
  validates :choices, presence: { if: :choices_required? }
  validate :formatting_parses

  scope :photos, -> { where(field_type: "Photo") }
  scope :non_photos, -> { where.not(field_type: "Photo") }
  scope :non_text_areas, -> { where.not(field_type: "Text Area") }
  scope :numeric, -> { where(field_type: "Numeric") }
  scope :weighted, -> { order("weight ASC") }
  scope :by_name, -> name { where(name: name) }
  scope :by_label, -> label { where(label: label) }
  scope :editable, -> { where(editable_by_user: true) }
  scope :has_access_control, ->  { where(has_access_control: true) }
  scope :for_print_template, -> { where("name in (?)",["value_proposed","recon_costs","prop_retail","value_approved","approved_reconditioning","approved_retail"]) }

  def type_lookup
    field_type.downcase.gsub(" ", "_")
  end

  def to_sym
    label.downcase.to_sym
  end

  def web_label
    print_label.nil? ? label : print_label
  end

  def choices_required?
    TYPES_WITH_CHOICES.include?(field_type)
  end

  def has_formatting?
    TYPES_WITH_FORMATTING.include?(field_type)
  end

  def choices_array
    choices.to_s.split("\r\n")
  end

  def parsed_formatting
    formatting.present? ? YAML.load(formatting) : {}
  end

  def numeric?
    field_type == "Numeric"
  end

  def display_attribute(organization,attr=:label)
    return self.send(attr) if organization.nil?
    field_access_control = FieldAccessControl.find_by(template_field_id: self.id, organization_id: organization.id)
    return self.send(attr) if field_access_control.nil?
    customized_attr_label = field_access_control.send(attr)
    customized_attr_label.present? ? customized_attr_label : self.send(attr)
  end

  def options(organization=nil)
    return self.choices_array if organization.nil?
    field_access_control = FieldAccessControl.find_by(template_field_id: self.id, organization_id: organization.id)
    return self.choices_array if field_access_control.nil?
    field_access_control.choices.to_s.split("\r\n")
  end

  # This field is showable based on whether the user's roles(under specified Org) have given view/edit access
  def showable?(mode=:view,organization,current_user)
   field_access_control = organization.field_access_controls.find_by(template_field_id: self.id)
   return true if field_access_control.nil? # meaning if no fac, there is no access defined
   org_specific_user_role_ids = current_user.roles.where("organization_id=?",organization.id).map(&:id)
   field_access_control_roles = field_access_control.roles(mode)
   (field_access_control_roles & org_specific_user_role_ids.map(&:to_s)).any?
  end

  private

  def formatting_parses
    return unless numeric?
    YAML.load(formatting)
  rescue Psych::SyntaxError
    errors.add(:formatting, "is not formatted properly")
  end
end
