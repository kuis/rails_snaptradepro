ActiveAdmin.register EmailTemplate do
  menu priority: 8

  actions :all
  form do |f|
    f.inputs do
      f.input :name, as: :string
      f.input :subject, as: :string
      f.input :body, as: :text
      f.input :is_active, label: "Active"
      f.input :purpose_trigger_action, as: :text, label: "Purpose,Trigger and Action"
      f.actions
    end
  end

  show :title => proc{|email_template| email_template.name.humanize }  do
    attributes_table do
      row :id
      row :name do |email_template|
        email_template.name.to_s.humanize
      end
      row "Subject" do |email_template|
        email_template.subject.html_safe
      end
      row "Body" do |email_template|
        email_template.body.html_safe
      end
      row "Active" do |email_template|
        email_template.is_active? ? "Yes" : "No"
      end
      row "Purpose,Trigger and Action" do |email_template|
        email_template.purpose_trigger_action.to_s
      end
      row :created_at
      row :updated_at
    end
  end
  index do
    id_column
    column :name do |email_template|
      email_template.name.to_s.humanize
    end
    column :subject
    column "Activated" do |email_template|
      email_template.is_active? ? "Yes" : "No"
    end
    actions
  end


end

