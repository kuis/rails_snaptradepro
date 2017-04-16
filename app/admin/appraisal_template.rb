ActiveAdmin.register AppraisalTemplate do
  menu priority: 3

  actions :all, except: :destroy
  action_item :only => :show do
    link_to 'Clone Template', clone_admin_appraisal_template_path(appraisal_template)
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :label
      f.input :agent, as: :boolean
      f.input :equipment_type, collection: EquipmentType.all.collect{|et|[et.name_with_label,et.id]}, include_blank: false
      f.inputs do
        f.template.render partial: 'appraisal_categories', locals: { f: f }
      end
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :label
      row "Equipmet Type" do
        appraisal_template.try(:equipment_type).try(:name_with_label)
      end
      row "Editable by Agent?" do
        appraisal_template.agent
      end
      row :created_at
      row :updated_at
    end

    appraisal_template.appraisal_categories.weighted.each do |category|
      category_text = "Category - #{category.label} (#{category.name})"
      category_text += " (weight #{category.weight})"

      panel category_text do
        table_for category.template_fields.weighted do
          column :name
          column :label
          column :weight
          column :field_type
        end
      end
    end
  end

  index do
    id_column
    column :name
    column "Equipmet Type" do |appraisal_template|
      appraisal_template.try(:equipment_type).try(:name_with_label)
    end
    column :label
    column :agent
    column :created_at
    column :updated_at

    actions
  end

  controller do
    def create
      category_ids = params[:appraisal_template][:appraisal_category_ids].split(',')
      params[:appraisal_template][:appraisal_category_ids] = category_ids
      super
    end

    def update
      category_ids = params[:appraisal_template][:appraisal_category_ids].split(',')
      params[:appraisal_template][:appraisal_category_ids] = category_ids
      super
    end
  end

  member_action :clone, :method => :get do
    appraisal_template = AppraisalTemplate.find(params[:id])
    AppraisalTemplate.clone(appraisal_template)

    redirect_to admin_appraisal_templates_path, notice: "Appraisal Template has been cloned"
  end
end
