class AppraisalSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :number, :status, :unit, :name, :organization,
             :appraisal_template, :categories

  has_one :customer
  has_one :user

  def organization
    if full_organization?
      OrganizationSerializer.root = false
      OrganizationSerializer.new(object.organization)
    else
      { id: object.organization_id }
    end
  end

  def appraisal_template
    AppraisalTemplateSerializer.root = false
    AppraisalTemplateSerializer.new(object.appraisal_template)
  end

  def categories
    object.appraisal_template.appraisal_categories.map do |category|
      AppraisalCategorySerializer.new(category, appraisal: object,
                                                completed_only: true,
                                                include_fields: true)
    end
  end

  def status
    {
      value: object.status,
      options: Appraisal::STATUSES
    }
  end

  attr_accessor :full_organization
  alias :full_organization? :full_organization

  attr_accessor :include_appraisal_template
  alias :include_appraisal_template? :include_appraisal_template

  attr_accessor :include_categories
  alias :include_categories? :include_categories
end
