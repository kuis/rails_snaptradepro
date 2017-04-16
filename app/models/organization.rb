class Organization < ActiveRecord::Base
  extend FriendlyId
  friendly_id :acronym, use: [:slugged, :finders]

  has_many :customers
  has_many :appraisals
  has_many :memberships
  has_many :users, through: :memberships
  has_many :appraisal_templates_organizations
  has_many :appraisal_templates, through: :appraisal_templates_organizations
  has_one :setting
  belongs_to :owner, foreign_key: 'owner_id', class_name: 'User'
  belongs_to :admin, foreign_key: 'admin_id', class_name: 'User'
  has_many :field_access_controls
  has_many :appraisal_columns
  has_many :equipment_types, through: :organization_equipment_types
  has_many :organization_equipment_types

  validates :name, presence: true
  validates :acronym, format: { with: /\A[A-Z]{3}\z/,
                                message: "Must be 3 capital letters"},
                      presence: true
  validates :owner, :admin, presence: true

  has_attached_file :map_image
  has_attached_file :company_logo
  
  accepts_nested_attributes_for :users

  validates_attachment_content_type :map_image, :content_type => /\Aimage\/.*\Z/
  validates_attachment_content_type :company_logo, :content_type => /\Aimage\/.*\Z/

  after_save :send_notification_to_admin

  def owner?(user)
    user == owner
  end

  def admin?(user)
    user == admin
  end

  def representatives
    rep_roles = Role.where(name: 'Rep').pluck(:id)
    users.joins(:memberships).where(memberships: { organization_id: id, role_id:  rep_roles }).distinct
  end

  def representatives?(user)
    membership = Membership.by_organization(id).by_user(user).representatives
    membership.present?
  end

  def member?(member)
    users.exists?(member) && !(admin?(member) || owner?(member))
  end

  def full_address
    "#{self.street_address}, #{self.city}, #{self.state} #{self.zipcode}"
  end

  def email_suffixes
    if email_suffix.present?
      email_suffix.delete(' ').split(',')
    else
      []
    end
  end

  def next_appraisal_number(increment: false)
    if increment
      self.increment!(:appraisal_sequence)
      number = self.appraisal_sequence
    else
      number = self.appraisal_sequence + 1
    end

    padded_number = sprintf("%06d", number)
    "#{acronym}-#{padded_number}"
  end

  def setting=(params)
    if self.setting.nil?
      params[:organization_id] = self.id
      Setting.create(params)
    else
      setting.update_attributes(params)
    end
  end

  def send_notification_to_admin
    MemberMailer.notify_news_of_being_org_admin(self).deliver if admin_id_changed?
    MemberMailer.notify_news_of_being_org_owner(self).deliver if owner_id_changed?
  end

  def template_fields_control
    TemplateField.where(id: FieldAccessControl.by_organization(self.id).map(&:template_field_id))
  end

  def fac_template_fields
    self.field_access_controls.includes(:template_field).collect{|fac| fac.template_field}
  end

  def organization_field_access
    self.field_access_controls
  end

  def is_field_disabled(field_name, role, type ='edit')
    field_id = TemplateField.try(:find_by, {name: field_name}).try(:id)
    false if field_id.nil?
    if FieldAccessControl.find_by(template_field_id: field_id, organization_id: self.id).nil?
      false
    else
      if type == 'view'
        roles = FieldAccessControl.find_by(template_field_id: field_id, organization_id: self.id).view_permission.try(:split, ",")
      else
        roles =  FieldAccessControl.find_by(template_field_id: field_id, organization_id: self.id).edit_permission.try(:split, ",")
      end
      if roles.nil?
        true
      else
        !roles.include?(role.to_s)
      end
    end
  end
  def is_field_hidden(field_name, role, type ='view')
    field_id = TemplateField.try(:find_by, {name: field_name}).try(:id)
    false if field_id.nil?
    if FieldAccessControl.find_by(template_field_id: field_id, organization_id: self.id).nil?
      false
    else
      if type == 'view'
        roles = FieldAccessControl.find_by(template_field_id: field_id, organization_id: self.id).view_permission.try(:split, ",")
      else
        roles =  FieldAccessControl.find_by(template_field_id: field_id, organization_id: self.id).edit_permission.try(:split, ",")
      end
      if roles.nil?
        true
      else
        !roles.include?(role.to_s)
      end
    end
  end
end
