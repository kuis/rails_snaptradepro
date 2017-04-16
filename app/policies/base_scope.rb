class BaseScope
  attr_accessor :user, :scope

  def initialize(user, scope)
    @user = user
    @scope = scope
  end
end
