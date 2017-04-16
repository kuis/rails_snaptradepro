class OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :name, :acronym, :appraisal_templates

  has_many :customers

  def appraisal_templates
    object.appraisal_templates.map do |template|
      # NAME SHOULD BE REMOVED FROM THIS WHEN IT'S SAFE
      visibility = object.appraisal_templates_organizations.where("appraisal_template_id = ?",template.id)
      attrs = template.attributes.symbolize_keys.slice(:id, :name, :label)
      attrs.merge!(:visibility => visibility.first.try(:is_visible)) if visibility.any?
      attrs
    end
  end
end
