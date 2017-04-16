class PrintTemplate < ActiveRecord::Base
  extend Enumerize

  has_many :print_template_blocks, dependent: :destroy
  belongs_to :appraisal_template

  enumerize :layout_type, in: [:sales_sheet, :appraisal_sheet],
                          scope: true,
                          predicates: { prefix: true },
                          default: :sales_sheet,
                          i18n_scope: "print_template.layout_type"
end
