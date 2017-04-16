class AppraisalColumnTemplateField < ActiveRecord::Base
  belongs_to :appraisal_column
  belongs_to :template_field
end
