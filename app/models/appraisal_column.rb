class AppraisalColumn < ActiveRecord::Base
  COLUMNS = %w(column1 column2 column3 column4 column5 column6)
  STATIC_FIELDS = [
      "number","unit","name","updated_at",
      "user.first_name","user.last_name",
      "valuation.requested_value","valuation.estimated_reconditioning", "valuation.prop_retail",
      "valuation.expected_acquisition_date", "valuation.value_approved", "valuation.approved_reconditioning",
      "valuation.approved_retail", "valuation.approved_good_until", "valuation.trade_conditions"
  ]
  validates :column_name, uniqueness: {scope: :organization_id}
  belongs_to :template_field
  belongs_to :organization

  has_many :appraisal_column_template_fields, dependent: :destroy
  has_many :template_fields, through: :appraisal_column_template_fields

  serialize :static_fields, Array

  def self.label_of(field='')
    field.to_s.split(".").last.to_s.humanize.titleize
  end

end
