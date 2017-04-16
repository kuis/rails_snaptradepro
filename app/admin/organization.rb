ActiveAdmin.register Organization do
  menu priority: 4
  skip_before_filter :load_organization

  actions :all, except: :destroy

  index do
    id_column
    column :name
    column :acronym
    column "owner" do |organization|
      organization.owner.try(:email)
    end
    column "rep(s)" do |organization|
      organization.memberships.representatives
      .map { |m| m.user.try(:email) }.compact.join(", ")
    end
    column :plan_name
    column :plan_pricing
    column "ET Enabled?", :is_equipment_type_enabled

    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :acronym
      row :plan_name
      row :plan_pricing
      row :plan_comments
      row :trade_name
      row "Address" do |organization|
        organization.full_address
      end
      row :call_to_action
      row :sale_sheet_phone
      row :toll_free
      row :main
      row :sales
      row :service
      row :parts
      row "ET Enabled?" do |organization|
        organization.is_equipment_type_enabled? ? "Yes" : "No"
      end

      row "Owner" do |organization|
        organization.owner.try(:name)
      end
      row :created_at
      row :updated_at
    end

    render partial: 'equipment_types_view', locals: {organization: organization} if organization.is_equipment_type_enabled?

    render partial: 'users_view', locals: {organization: organization}

    render partial: 'appraisal_templates_view', locals: {organization: organization}

  end

  form html: {enctype: "multipart/form-data"} do |f|
    f.inputs "Organization Details" do
      f.input :name, hint: "This is the name of the organization, not the user."
      f.input :acronym, hint: "3 Capital letters.  Example: 'ABC', 'MET'",
              input_html: {disabled: organization.persisted?}
      f.input :email_suffix, hint: "This must begin with @ symbol. Example: @snaptradepro.com, @dealer.com"
      f.input :plan_name, hint: "internal use only"
      f.input :plan_pricing, hint: "internal use only"
      f.input :plan_comments, hint: "internal use only", input_html: {rows: 7}
      f.input :is_equipment_type_enabled, hint: "internal use only",label: "ET Enabled?"
    end



    f.inputs class: "et_wrapper inputs", style: f.object.is_equipment_type_enabled? ? "display:block" : "display:none" do
      f.template.render partial: 'equipment_types', locals: {f: f}
    end

    f.inputs "Organization Public Information" do
      f.input :trade_name
      f.input :street_address
      f.input :city
      f.input :state
      f.input :zipcode
      f.input :call_to_action
      f.input :sale_sheet_phone
      f.input :company_logo, as: :file, hint: f.object.company_logo.present? \
                                              ? f.template.image_tag(f.object.company_logo.url, class: "img-sm")
                                              : f.template.content_tag(:span, "No company logo yet")
      f.input :toll_free
      f.input :main
      f.input :sales
      f.input :service
      f.input :parts
      f.input :commentary, as: :text, input_html: {rows: 7}
      f.input :warranty, as: :text, input_html: {rows: 7}
      f.input :location
      f.input :map_image, as: :file, hint: f.object.map_image.present? \
                                           ? f.template.image_tag(f.object.map_image.url, class: "img-sm")
                                           : f.template.content_tag(:span, "No map image yet")

      f.input :sale_term_conditions, as: :text, input_html: {rows: 7}
      f.input :term_guidelines, as: :text, input_html: {rows: 7}
      f.input :internal_trade_policy, as: :text, input_html: {rows: 7}
    end

    f.inputs "Settings", :for => [:setting, f.object.setting || Setting.new] do |s|
      s.input :header_color, input_html: {class: "colorpicker"}
      s.input :sub_header_color, input_html: {class: "colorpicker"}
      s.input :sub_background_color, input_html: {class: "colorpicker"}
      s.input :text_color, input_html: {class: "colorpicker"}
      s.input :body_text_color, input_html: {class: "colorpicker"}
      s.input :highlight_line_color, input_html: {class: "colorpicker"}
      s.input :comment_text_color, input_html: {class: "colorpicker"}
    end

    f.inputs "Owner and Admin" do
      f.input :owner, as: :select, collection: staff_with_role(f.object)
      f.input :admin, as: :select, collection: staff_with_role(f.object)
    end

    f.inputs do
      f.template.render partial: 'users', locals: {f: f}
    end

    f.inputs do
      f.template.render partial: 'appraisal_templates', locals: {f: f}
    end


    #organization, field_access_control and template_fields
    organization_controlled_fields = f.object.template_fields_control
    organization_field_access = f.object.organization_field_access
    unless f.object.new_record?
      f.inputs "Field Access Control" do
        f.template.render partial: 'fields_with_control', locals: {f: f, organization_fields: organization_controlled_fields, field_access: organization_field_access}
      end
    end

    f.actions
  end

  controller do
    def create
      @view_permission = params[:view_permission]
      @edit_permission = params[:edit_permission]
      params.delete :view_permission
      params.delete :edit_permission
      params.delete :organization_template_field_ids
      #create only organization
      super
    end

    def update
      view_permission = params[:view_permission]
      edit_permission = params[:edit_permission]
      @organization = Organization.find(params[:id])
      @organization.fac_template_fields.each do |template_field|
        access = @organization.field_access_controls.find_by(template_field_id: template_field.id)
        access.view_permission = view_permission[template_field.id.to_s].join(",") rescue ""
        access.edit_permission = edit_permission[template_field.id.to_s].join(",") rescue ""
        access.save
      end
      params.delete :view_permission
      params.delete :edit_permission
      params.delete :organization_template_field_ids
      #update only organization
      super
    end
  end
end
