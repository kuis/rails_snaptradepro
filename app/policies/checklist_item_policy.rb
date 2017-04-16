class ChecklistItemPolicy < BasePolicy
  def checklist_item
    resource
  end

  def in_organization?
    organization = checklist_item.checklist.appraisal.organization
    user.admin? || Membership.find_by(user: user, organization: organization)
  end

  alias_method :create?, :in_organization?
  alias_method :new?, :in_organization?
  alias_method :edit?, :in_organization?
  alias_method :update?, :in_organization?
  alias_method :destroy?, :in_organization?
  alias_method :completed?, :in_organization?
  alias_method :uncompleted?, :in_organization?
end
