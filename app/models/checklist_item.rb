class ChecklistItem < ActiveRecord::Base
  belongs_to :checklist

  validates :description, presence: true
end
