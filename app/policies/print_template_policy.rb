class PrintTemplatePolicy < BasePolicy
  def super_admin?
    user.admin?
  end

  alias_method :index?, :super_admin?
  alias_method :new?, :super_admin?
  alias_method :create?, :super_admin?
  alias_method :edit?, :super_admin?
  alias_method :update?, :super_admin?
  alias_method :destroy?, :super_admin?
end
