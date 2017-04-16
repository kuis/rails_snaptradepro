CustomerPolicy = Struct.new(:user, :customer) do
  def in_organization?
    organization = customer.organization
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
  alias_method :bulk_archive?, :in_organization?
end
