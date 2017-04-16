class AppraisalTemplatesOrganization < ActiveRecord::Base
  belongs_to :appraisal_template
  belongs_to :organization
end
