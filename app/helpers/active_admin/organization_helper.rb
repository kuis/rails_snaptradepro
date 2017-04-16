module ActiveAdmin::OrganizationHelper
  def staff_with_role(organization)
    staff = organization.representatives.where.not(admin: true) + User.where(admin: true)
    staff.map { |u| ["#{u.name} (#{u.email})#{u.admin? ? ' - STP Admin' : ''}", u.id] }
  end
end
