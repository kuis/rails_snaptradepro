class AttachmentPolicy < BasePolicy
  def attachable
    resource.attachable_type.constantize.find(resource.attachable_id)
  end

  def in_organization?
    organization = attachable.organization
    user.admin? || Membership.find_by(user: user, organization: organization)
  end

  alias_method :create?, :in_organization?
  alias_method :destroy?, :in_organization?
end
