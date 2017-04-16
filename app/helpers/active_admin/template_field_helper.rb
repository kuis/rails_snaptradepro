module ActiveAdmin::TemplateFieldHelper
  def formatting_value(field, key)
    if field.present?
      field.parsed_formatting[key]
    end
  end


end
