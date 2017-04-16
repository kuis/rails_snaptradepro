class ChecklistPolicy < BasePolicy
  def checklist
    resource
  end

  def in_organization?
    organization = checklist.appraisal.organization
    user.admin? || Membership.find_by(user: user, organization: organization)
  end

  alias_method :create?, :in_organization?
  alias_method :new?, :in_organization?
  alias_method :edit?, :in_organization?
  alias_method :update?, :in_organization?
  alias_method :destroy?, :in_organization?
end
