class AppraisalTemplatePolicy < BasePolicy
  class Scope < BaseScope
    def resolve
      membership = Membership.by_user(user)
                             .by_organization(user.current_organization)
                             .representatives
      if user.admin? || membership.present?
        scope.all
      else # agent?
        scope.where(agent: true)
      end
    end
  end
end
