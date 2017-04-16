class Comment < ActiveRecord::Base
  include ActsAsCommentable::Comment

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  default_scope -> { order('created_at ASC') }

  validates :comment, presence: true
  validates :price, numericality: true, unless: :commentable_type_is_discussion_or_valuation_comment
  validates :state_of_sale, presence: true, if: "commentable_type != 'Discussion'"

  def commentable_type_is_discussion_or_valuation_comment
    self.commentable_type == "Discussion" ||
    self.commentable_type == "ValuationUrl"
  end
end
