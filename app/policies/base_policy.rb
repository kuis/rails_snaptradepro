class BasePolicy
  attr_accessor :user, :resource

  def initialize(user, resource)
    @user = user
    @resource = resource
  end
end
