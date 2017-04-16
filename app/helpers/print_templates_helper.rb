module PrintTemplatesHelper
  def numeric_template_fields(default_value)
    options = "<option value=''>No Value</option>"
    options += options_from_collection_for_select(TemplateField.for_print_template, 'id', 'label', default_value)
    options.html_safe
  end
end
