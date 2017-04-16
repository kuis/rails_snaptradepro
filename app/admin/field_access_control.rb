ActiveAdmin.register FieldAccessControl do

  filter :organization
  filter :view_permission
  filter :edit_permission
  filter :label
  filter :print_label
  filter :choices

  filter :template_field_name, as: :string, label: "Field Name"
  filter :template_field_id, as: :numeric, label: "Field Number"

  actions :all
  index do
    selectable_column
    id_column
    column "Organization Name" do |field_access_control|
      link_to field_access_control.organization.name, admin_organization_path(field_access_control.organization) if field_access_control.organization.present?
    end
    column :template_field_id, as: :select, collection: TemplateField.all.collect { |field| [field.name, field.id]}
    column "Template Field Name" do |field_access_control|
      link_to field_access_control.template_field.name, admin_template_field_path(field_access_control.template_field)
    end
    column "Label" do |field_access_control|
      field_access_control.template_field.label
    end
    column "Print Label" do |field_access_control|
      field_access_control.template_field.print_label
    end
    column :view_permission
    column :edit_permission
    actions
  end

  form do |f|
    f.inputs 'Field Access Control Details' do
      f.input :view_permission, as: :boolean if f.object.new_record?
      f.input :edit_permission, as: :boolean if f.object.new_record?

      f.inputs do
        f.template.render partial: 'organizations_fac', locals: { f: f }
      end

      f.inputs do
        f.template.render partial: 'template_fields_fac', locals: { f: f }
      end
      hint = "FOR SELECT: <br>
              This is a list of choices if the field type requires it.  Separate by new line.
              ".html_safe

      f.input :choices, hint: hint
      f.input :label, as: :string
      f.input :print_label, as: :string
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :organization
      row :template_field
      row :view_permission do |fac|
        Role.where("id IN (?)", fac.view_permission.split(",")).map(&:profile_name).join(', ')
      end
      row :edit_permission do |fac|
        Role.where("id IN (?)", fac.edit_permission.split(",")).map(&:profile_name).join(', ')
      end
    end
  end

  batch_action :destroy, confirm: "Are you sure?" do |ids|
    FieldAccessControl.where(id: ids).destroy_all
    redirect_to admin_field_access_controls_path, notice: "Selected FACs has been removed successfully."
  end
end
