class CommentPolicy < BasePolicy
  def in_comment?
    true
  end

  alias_method :comment?, :in_comment?
  alias_method :reveal_comments?, :in_comment?
  alias_method :hide_comments?, :in_comment?
  alias_method :create?, :in_comment?
  alias_method :show?, :in_comment?
  alias_method :new?, :in_comment?
end
