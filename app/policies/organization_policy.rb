class OrganizationPolicy < BasePolicy
  def organization
    resource
  end

  def has_full_permission?
    user.admin? || organization.admin?(user) || organization.owner?(user)
  end

  def has_read_permission?
    has_full_permission? || organization.representatives?(user)
  end

  alias_method :show?, :has_read_permission?
  alias_method :edit?, :has_full_permission?
  alias_method :update?, :has_full_permission?

  class Scope < BaseScope
    def resolve
      if user.admin?
        scope.all
      else
        scope.joins(:memberships)
             .where(memberships: { user_id: user.id })
      end
    end
  end
end
