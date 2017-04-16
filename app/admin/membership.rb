ActiveAdmin.register Membership do
  menu priority: 5

  actions :all, except: [:new, :create, :show]

  index do
    column "Name" do |membership|
      membership.user.name
    end
    column "Email" do |membership|
      membership.user.email
    end
    column :organization
    column "Role" do |membership|
      membership.role.try(:name)
    end
    column "Profile" do |membership|
      membership.role.try(:profile)
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :name, input_html: { disabled: true, value: f.object.user.name }
      f.input :user_email, input_html: { disabled: true, value: f.object.user.email }
      f.input :organization, input_html: { disabled: true }
      f.input :email
      f.input :active
      f.input :job_title, label: "Role Title"
      f.input :contact_phone, label: "Public Contact Phone"
      f.input :avatar, as: :file,
                       label: "Head Image",
                       hint: f.object.avatar.present? \
                       ? f.template.image_tag(f.object.avatar.url, class: "img-sm")
                       : f.template.content_tag(:span, "No avatar yet")
    end

    f.actions
  end
end
