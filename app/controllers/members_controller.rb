class MembersController < ApplicationController
  before_action :current_organization, except: [:accept_invitation]
  before_action :find_member, except: [:invite_user, :index, :accept_invitation]
  skip_before_action :authenticate_user!, only: [:accept_invitation]
  skip_after_action :verify_authorized, only: [:accept_invitation]

  def index
    authorize @organization, :show?
    @members = @organization.users
                            .includes(:memberships)
                            .order('memberships.active DESC, memberships.role_id ASC')
  end

  def show
  end

  def update
    @member.update_attributes(member_params)
    redirect_to organization_members_path(@organization), notice: 'Updated member successfully.'
  end

  def invite_user
    authorize @organization, :update?

    if !email_suffixes_include_email_domain(@organization, params[:user][:email])
      @email_suffix_not_allowed = true and return
    end

    @member = User.find_by(email: params[:user][:email])
    if @member
      if @organization.users.where(id: @member.id).present?
        @member.errors[:base] = 'User has already been a member of this organization'
      else
        role = Role.find(params[:user][:memberships_attributes]['0'][:role_id])
        @membership = @organization.memberships.create({ user: @member, role: role })
      end
    else
      @member = User.invite!(user_params) do |u|
        u.skip_invitation = true
      end
    end

    if @member.present?
      @membership = @organization.memberships.find_by(user: @member)
      @membership.invite!(@member, current_user)
    end
  end

  def accept_invitation
    tokens = params[:invitation_token].split(',')
    membership = Membership.find_by(invitation_token: tokens[0])
    if membership.present?
      membership.accept_invitation!
      if user_invitation_accepted?(tokens) # If user invitation has not been accepted yet
        flash[:notice] = "Now you are #{membership.role.profile} of #{membership.organization.name}"
        redirect_to new_session_path(membership.user)
      else
        redirect_to accept_invitation_path(membership.user, invitation_token: tokens[1])
      end
    else
      redirect_to root_path, alert: I18n.t('devise.invitations.invitation_token_invalid')
    end
  end

  def resend_invitation
    if email_suffixes_include_email_domain(@organization, @member.email)
      @membership = @organization.memberships.find_by(user: @member)
      @membership.invite!(@member, current_user)
      render json: { invitation_sent: true }
    else
      render json: { invitation_sent: false }
    end
  end

  def reset_password
    User.send_reset_password_instructions(@member)
    head :ok
  end

  private

  def find_member
    @member = User.find(params[:id])
    member_authorize
  end

  def member_authorize
    member_context = MemberContext.new(@member, @organization)
    self.policy = UserPolicy.new(current_user, member_context)
    authorize(member_context)
  end

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      memberships_attributes: [:organization_id, :role_id]
    )
  end

  def member_params
    permitted_params = [
      :street_address,
      :city,
      :state,
      :postal_code,
      :business_phone,
      :mobile_phone,
    ]

    # if user is owner or admin of current organization, allow current user to update email and name
    if @organization.admin?(current_user) || @organization.owner?(current_user)
      permitted_params += [:email, :first_name, :last_name]
    end
    permitted_params += [
      memberships_attributes: [
        :id, 
        :email, 
        :job_title, 
        :contact_phone, 
        :avatar, 
        :organization_id, 
        :active, 
        :_destroy
      ]
    ]
    params.require(:member).permit(permitted_params)
  end

  def email_suffixes_include_email_domain(organization, email)
    email_domain = "@" + email.split("@").last
    return organization.email_suffixes.blank? || organization.email_suffixes.include?(email_domain)
  end

  def user_invitation_accepted?(tokens)
    tokens[1].nil?
  end
end
