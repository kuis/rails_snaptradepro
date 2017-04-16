module FormHelper
  def custom_field_name(id)
    "appraisal[custom_fields][#{id}]"
  end

  def basic_jarvis_box(header, &block)
    content_tag :div, id: "wid-id-1",
                      class: "jarviswidget no-filter",
                      data: { "widget-editbutton" => "false" } do
      concat jarvis_header(header)
      concat jarvis_body(&block)
    end
  end

  def pinnable_jarvis_box(header, pinnable_id, on_valuation_page = false,&block)
    content_tag :div, id: "wid-id-1",
                      class: "jarviswidget no-filter",
                      data: { "widget-editbutton" => "false" } do
      concat jarvis_header(header, pinnable_id, on_valuation_page)
      concat jarvis_body(&block)
    end
  end

  def jarvis_header(text, pinnable_id = nil, on_valuation_page = false)
    content_tag :header do
      concat content_tag :h2, content_tag(:strong, text)

      if pinnable_id.present?
        concat content_tag(:div, fa_icon("thumb-tack"), class: "pinnable #{'pinned' if (@pinned_items.present? && @pinned_items.include?(pinnable_id)) || on_valuation_page}",
                           data: { "behavior" => "pinnable",
                                  "pinnable-id" => pinnable_id })
      end
    end
  end

  def jarvis_body(&block)
    content_tag :div do
      concat content_tag :div, nil, class: "jarviswidget-editbox"
      concat jarvis_content(&block)
    end
  end

  def jarvis_content(&block)
    content_tag :div, class: "widget-body" do
      capture(&block)
    end
  end
end
