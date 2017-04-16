class DiscussionCommentsController < ApplicationController
  def new
    @comment = Comment.new
    @discussion = Discussion.find(params[:id])
    @appraisal = @discussion.appraisal
    @organization = @appraisal.organization

    authorize @comment
  end

  def create
    @discussion = Discussion.find(params[:discussion_id])
    @comment = Comment.new(comment: discussion_comment_params[:comment], commentable_id: params[:discussion_id], commentable_type: "Discussion", user_id: current_user.id)
    @comment.save

    authorize @comment
  end

  def show
    @comments = Comment
      .where(commentable_type: "Discussion", commentable_id: params[:id])
    @discussion = Discussion.find(params[:id])
    @appraisal = @discussion.appraisal

    authorize @comments
  end

  private

  def discussion_comment_params
    params
      .require(:comment)
      .permit(:comment)
  end
end
