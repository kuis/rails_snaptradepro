class Checklist < ActiveRecord::Base
  belongs_to :appraisal
  has_many :checklist_items
  validates :name, presence: true
end
