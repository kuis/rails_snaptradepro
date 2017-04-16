ActiveAdmin.register AppraisalCategory do
  menu priority: 2

  actions :all, except: :destroy
  action_item :only => :show do
    link_to 'Clone Category', clone_admin_appraisal_category_path(appraisal_category)
  end
  form do |f|
    f.inputs do
      f.input :name
      f.input :label
      f.input :weight, hint: "Must be a number between 0 and 100 inclusive.  Low weight appears at top of page, high weight appears at bottom of page."
      f.inputs do
        f.template.render partial: 'template_fields', locals: { f: f }
      end
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :label
      row :weight
      row :created_at
      row :updated_at
    end

    panel "Fields" do
      table_for appraisal_category.template_fields.weighted do
        column :name
        column :label
        column :print_label
        column :weight
        column :field_type
      end
    end
  end

  controller do
    def create
      template_ids = params[:appraisal_category][:template_field_ids].split(',')
      params[:appraisal_category][:template_field_ids] = template_ids
      super
    end

    def update
      template_ids = params[:appraisal_category][:template_field_ids].split(',')
      params[:appraisal_category][:template_field_ids] = template_ids
      super
    end
  end

  member_action :clone, :method => :get do
    appraisal_category = AppraisalCategory.find(params[:id])
    AppraisalCategory.clone(appraisal_category)

    redirect_to admin_appraisal_categories_path, notice: "Appraisal Category has been cloned"
  end
end
