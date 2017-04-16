class ValuationUrl < ActiveRecord::Base
  acts_as_commentable
  belongs_to :appraisal
end
