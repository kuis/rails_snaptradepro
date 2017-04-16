ActiveAdmin.register AppraisalColumn do
  menu priority: 7

  actions :all
  form do |f|
    f.inputs do
      f.input :column_name, as: :select, collection: AppraisalColumn::COLUMNS, include_blank: false
      f.input :organization, as: :select, collection: Organization.order(:name), include_blank: false

      f.inputs do
        f.template.render partial: 'template_fields', locals: { f: f }
      end
    end
    f.actions
  end
  index do
    id_column
    column :column_name
    column :static_fields
    column :template_fields, :sortable => 'template_fields.name' do |appraisal_column|
      appraisal_column.template_fields.map(&:name)
    end
    # column "Label", :sortable => 'template_fields.label' do |appraisal_column|
    #   appraisal_column.template_field.try(:label)
    # end
    column :organization
    actions
  end

  show do
    attributes_table do
      row :id
      row :column_name
      row :organization
      row :static_fields
      row :template_fields do |appraisal_column|
        appraisal_column.template_fields.map(&:name)
      end
      row :created_at
      row :updated_at
    end

  end

  controller do
    def scoped_collection
      end_of_association_chain.includes(:template_fields)
    end
    def update
      params[:appraisal_column][:static_fields] = params[:appraisal_column][:static_fields] || []
      super
    end
  end
end
