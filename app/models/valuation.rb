class Valuation < ActiveRecord::Base
  has_paper_trail on: [:update, :destroy]
  belongs_to :appraisal
end
