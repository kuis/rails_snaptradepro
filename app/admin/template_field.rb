ActiveAdmin.register TemplateField do
  menu priority: 1

  index do
    id_column
    column :name
    column :field_type
    column :label
    column :print_label
    column :choices
    column :required
    column :formatting
    column :weight
    column :cloneable
    column :has_access_control
    column :updated_at
    column :has_effect_on_other_fields
    column :editable_by_user
    actions
  end

  form do |f|
    f.actions
    f.inputs do
      f.input :name
      f.input :field_type, as: :select, collection: TemplateField::FIELD_TYPES
      f.inputs do
        f.template.render partial: 'formatting', locals: { f: f }
      end
      f.input :label
      f.input :print_label
      f.input :weight
      f.input :required, as: :boolean
      f.input :cloneable, as: :boolean
      f.input :has_effect_on_other_fields
      f.input :editable_by_user
      f.input :has_access_control, as: :boolean
      f.input :appraisal_categories, as: :check_boxes


      if template_field.new_record? || template_field.choices_required?
        hint = "FOR SELECT AND CHECK BOXES: <br>
                This is a list of choices if the field type requires it.  Separate by new line.
          ".html_safe
        f.input :choices, hint: hint
      end
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :label
      row :print_label
      row :weight
      row :required
      row :cloneable
      row :field_type
      row :has_access_control
      row :updated_at
      if template_field.choices.present?
        row "choices" do
          template_field.choices.gsub("\n", "<br>").html_safe
        end
      end
      if template_field.formatting.present?
        row "formatting" do
          template_field.formatting.gsub("\n", "<br>").html_safe
        end
      end
    end

    panel "Categories" do
      table_for template_field.appraisal_categories do
        column :name
        column :label
      end
    end
  end

  controller do
    def create
      @template_field = TemplateField.new(params[:template_field])
      @template_field.formatting = formatting
      if @template_field.save
        redirect_to admin_template_field_path(@template_field),
                  notice: "Template field updated successfully"
      else
      end
    end

    def update
      @template_field = TemplateField.find(params[:id])
      @template_field.formatting = formatting
      @template_field.update_attributes(params[:template_field])
      redirect_to admin_template_field_path(@template_field),
                notice: "Template field updated successfully"
    end

    private

    def formatting
      formats = Array.new
      params[:formatting] = params[:formatting].select{|k, v| v.present?}
      params[:formatting].each do |key, value|
        formats.push "#{key.dasherize}: #{value}"
      end
      formats.join("\r\n")
    end
  end
end
