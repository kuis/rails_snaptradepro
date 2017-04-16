module ApplicationHelper
  def flash_messages(opts={})
    @layout_flash = opts.fetch(:layout_flash) { true }

    capture do
      flash.each do |name, msg|
        concat content_tag(:div, msg.html_safe, id: "flash_#{name}")
      end
    end
  end

  def show_left_nav?
    return false if @show_left_nav == false

    user_signed_in? && @organization
  end

  def show_layout_flash?
    @layout_flash.nil? ? true : @layout_flash
  end

  def breadcrumbs
    @breadcrumbs ||= []
    @breadcrumbs
  end

  def pdf_image_tag(src, options = {})
    return if src.nil?
    src = gsub_https(src)
    image_tag src, options
  end

  def gsub_https(src)
    src.gsub!('https://', 'http://')
    src
  end

  def pdf_preview_link(organization, appraisal)
    eval("#{params[:action]}_organization_appraisal_path(organization, appraisal, format: :pdf)")
  end

  def filepicker_url(image, size: :small)
    return image unless image.include?("filepicker")

    options = { cache: true }

    if size == :small
      image = "#{image}/convert"
      options.merge!({ w: "200", h: "200" })
    end

    "#{image}?#{options.to_query}"
  end

  def display_column_header(default_text,column_number)
    column_data = @columns[column_number.to_i]
    column = params["column#{column_number}".to_sym] || session[:columns]["column#{column_number}"]

    return default_text if column_data.nil?

    selected_template_field = column_data.template_fields.find_by_id(column)

    if selected_template_field.present?
      template_field = column_data.template_fields.find(selected_template_field.id)
      template_field.display_attribute(@organization,:label)
    elsif column_data.static_fields.include?(column)
      AppraisalColumn.label_of(column)
    else
      AppraisalColumn.label_of(default_text)
    end
  end

  def display_column_data(column_number=nil,object=nil, default_attr=nil)
    column_data = @columns[column_number.to_i]
    column = params["column#{column_number}".to_sym] || session[:columns]["column#{column_number}"]

    return yield if block_given?
    return object.send(default_attr.to_sym) if column_data.nil?

    selected_template_field = column_data.template_fields.find_by_id(column)

    if selected_template_field.present?
      template_field = column_data.template_fields.find(selected_template_field.id)
      object.field_value(template_field.id,true)
    elsif column_data.static_fields.include?(column)
      eval("object.#{column}") rescue "" #eval() is safe here because the dynamic attr which are listed in the static_fields by the STP Admin
      #object.send(column.to_sym)
    else
      object.send(default_attr.to_sym)
    end
  end

  def options_for_selectable_fields(organization,column)
    appraisal_column = organization.appraisal_columns.find_by_column_name(column)
    return [] if appraisal_column.nil?
    appraisal_column.template_fields.collect{|tf| [tf.display_attribute(@organization).humanize,tf.id]} + appraisal_column.static_fields.collect{|sf| [AppraisalColumn.label_of(sf),sf]}
  end

end
