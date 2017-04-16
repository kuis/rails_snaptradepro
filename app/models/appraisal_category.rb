class AppraisalCategory < ActiveRecord::Base
  has_and_belongs_to_many :template_fields
  has_and_belongs_to_many :appraisal_templates

  validates :name, presence: true, uniqueness: true
  validates :label, presence: true
  validates :weight, presence: true, numericality: true, inclusion: 0..100

  scope :weighted, -> { order("weight ASC") }
  scope :without_id, -> { where.not(label: "Identification") }

  def self.clone(category)
    cloned = category.dup
    cloned.name = "Cloned - #{cloned.name} #{AppraisalCategory.count}"
    cloned.save!

    # clone appraisal categories
    category.template_fields.each do |template_field|
      cloned.template_fields << template_field
    end

    cloned
  end
end
