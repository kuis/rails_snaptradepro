module ReportHelper
  def get_appraisal_value_by_name(appraisal, field_name)
    return unless field_name
    appraisal.field_readable_value(TemplateField.by_name(field_name).first)
  end
end
