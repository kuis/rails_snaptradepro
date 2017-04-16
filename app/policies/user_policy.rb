class UserPolicy
  attr_accessor :user, :member_context

  def initialize(user, member_context)
    @user = user
    @member_context = member_context
  end

  def organization
    member_context.organization
  end

  def member
    member_context.member
  end

  def has_read_permission?
    organization.representatives?(user) || has_full_permission?
  end

  def has_full_permission?
    return true if user == member
    organization.admin?(user) || organization.owner?(user)
  end

  alias_method :show?, :has_read_permission?
  alias_method :update?, :has_full_permission?
  alias_method :reset_password?, :has_full_permission?
  alias_method :resend_invitation?, :has_full_permission?
end
