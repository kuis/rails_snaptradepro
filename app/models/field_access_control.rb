class FieldAccessControl < ActiveRecord::Base

  belongs_to :organization
  belongs_to :template_field

  validates :organization_id, presence: true
  validates :template_field_id, presence: true
  validates :organization_id, uniqueness: {scope: :template_field_id, message: " and the template field has already been taken"}

  scope :by_organization, -> org { where(organization_id: org) }

  def choices_array
    choices.to_s.split("\r\n")
  end

  def roles(mode=:view)
    mode == :edit ? self.edit_permission.to_s.split(",") : self.view_permission.to_s.split(",")
  end
end
