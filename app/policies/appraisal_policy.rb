class AppraisalPolicy < BasePolicy
  def appraisal
    resource
  end

  def in_organization?
    organization = appraisal.organization
    user.admin? || Membership.find_by(user: user, organization: organization)
  end

  alias_method :index?, :in_organization?
  alias_method :show?, :in_organization?
  alias_method :new?, :in_organization?
  alias_method :create?, :in_organization?
  alias_method :edit?, :in_organization?
  alias_method :update?, :in_organization?
  alias_method :destroy?, :in_organization?
  alias_method :archive?, :in_organization?
  alias_method :archived?, :in_organization?
  alias_method :clone?, :in_organization?
  alias_method :sales_sheet?, :in_organization?
  alias_method :appraisal_sheet?, :in_organization?
  alias_method :bulk_archive?, :in_organization?
  alias_method :remove_entry?, :in_organization?
  alias_method :history?, :in_organization?
  alias_method :comment?, :in_organization?
  alias_method :valuations?, :in_organization?
  alias_method :pin?, :in_organization?
  alias_method :unpin?, :in_organization?
  alias_method :valuation?, :in_organization?
  alias_method :convert_et?, :in_organization?
  alias_method :find_et_templates?, :in_organization?

  class Scope < BaseScope
    def resolve
      if user.admin?
        scope.all
      else
        scope.joins(organization: [:memberships])
             .where(memberships: { user_id: user.id })
      end
    end
  end
end
