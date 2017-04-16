class EquipmentTypePolicy < BasePolicy
  def equipment_type
    resource
  end

  class Scope < BaseScope
    def resolve
      if user.admin?
        scope.all
      else
        scope.joins(organizations: [:memberships])
             .where(memberships: { user_id: user.id })
      end
    end
  end
end
