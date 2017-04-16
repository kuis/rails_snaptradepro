module AppraisalsHelper
  def get_org_heading_style(org)
    style = ""
    style = "color: #{org.setting.header_color};" if org.setting.try(:header_color)
    style += "background-color: #{org.setting.sub_background_color};" if org.setting.try(:sub_background_color)
  end

  def org_color(style)
    return 'n/a' if @organization.setting.nil?
    color = @organization.setting.send(style)
    color.present? ? color : 'n/a'
  end

  def get_appraisal_entry_value_by_label(appraisal, field_label)
    template_field = TemplateField.find_by(label: field_label)
    return unless template_field
    appraisal.field_readable_value(category.template_fields.by_label(field_label).first)
  end

  def get_appraisal_entry_value_by_name(appraisal, field_name)
    template_field = TemplateField.find_by(name: field_name)
    return unless template_field
    appraisal.field_value(template_field.id)
  end

  def get_appraisal_entry_value(appraisal, template_field_id)
    appraisal.field_value(template_field_id)
  end

  def get_appraisal_web_label(appraisal, field_id)
    template_field = TemplateField.find_by(id: field_id)
    return unless template_field
    template_field.web_label
  end

  def valuation_change_td_tag(version, attribute)
    changed_keys = version.changeset.keys
    valuation = version.reify
    if changed_keys.include? attribute
      content_tag :td, version.changeset[attribute].last, class: 'text-danger strong'
    else
      content_tag :td, valuation.try(attribute)
    end
  end
end
