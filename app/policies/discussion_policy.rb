class DiscussionPolicy < BasePolicy
  def in_discussion?
    true
  end

  alias_method :create?, :in_discussion?
  alias_method :show?, :in_discussion?
end
