class PrintTemplateBlock < ActiveRecord::Base
  belongs_to :print_template

  scope :photos,     -> { where(blockable_type: 'photo') }
  scope :tables,     -> { where(blockable_type: %w(table divider)) }
  scope :numeric,    -> { where("blockable_type = 'numeric' AND blockable_id IS NOT NULL") }
  scope :user_ids,   -> { where(blockable_type: 'user') }
  scope :by_page,    -> page { where(page: page) }
  scope :by_section, -> section { where(section: section) }
end
