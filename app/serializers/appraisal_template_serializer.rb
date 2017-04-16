class AppraisalTemplateSerializer < ActiveModel::Serializer
  attributes :id, :label

  has_many :appraisal_categories
end
