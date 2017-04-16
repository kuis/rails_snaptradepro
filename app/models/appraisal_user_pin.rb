class AppraisalUserPin < ActiveRecord::Base
  belongs_to :appraisal
  belongs_to :user
  belongs_to :appraisal_category
end
