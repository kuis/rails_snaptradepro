class Discussion < ActiveRecord::Base
  acts_as_commentable
  belongs_to :appraisal
  accepts_nested_attributes_for :comments
end
