ActiveAdmin.register User do
  menu priority: 6
  config.per_page = 25

  actions :index, :show, :new, :create, :edit, :update, :resend_invitation

  scope :unarchived, default: true
  scope :archived

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :created_at
    column :updated_at
    column :admin
    column :active
    actions
  end

  form do |f|
    f.inputs do
      if f.object.new_record?
        f.input :email, hint: "User will be sent an email invitation to create a password."
      else
        f.input :email
      end

      f.input :first_name
      f.input :last_name

      f.input :street_address
      f.input :city
      f.input :state, label: "State/Province"
      f.input :postal_code, label: "Zip/Postal"
      f.input :business_phone
      f.input :mobile_phone
      f.input :active
      f.input :archived

      f.has_many :memberships, :heading => 'Memberships' do |m|
        m.input :role, as: :select,
                       collection: Role.staff.collect {|r| ["#{r.name} - #{r.profile}", r.id]}
        m.input :organization, as: :select,
                               collection: Organization.all.collect {|o| [o.name, o.id]}
      end
    end
    f.actions
  end

  batch_action :archive, if: proc{ params[:scope] != 'archived' } do |ids|
    User.where(id: ids).update_all({ archived: true, active: false })
    redirect_to admin_users_path, notice: "Selected users have been archived successfully."
  end

  batch_action :unarchive, if: proc{ params[:scope] == 'archived' } do |ids|
    User.where(id: ids).update_all(archived: false)
    redirect_to admin_users_path, notice: "Selected users have been unarchived successfully."
  end

  member_action :resend_invitation, method: :get do
    user = User.find(params[:id])
    user.invite!(current_user)
    redirect_to [:admin, user], notice: "Sent user invitation again successfully."
  end

  action_item only: :show do
    link_to 'Resend Invitation', resend_invitation_admin_user_path(user)
  end

  controller do
    def create
      if User.where(email: params[:user][:email]).exists?
        redirect_to admin_users_path, alert: "Email already taken."
      else
        @user = User.invite!(params[:user], current_user)
        redirect_to admin_user_path(@user), notice: "User invited successfully."
      end
    end
  end
end
