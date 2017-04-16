class ValuationUrlCommentsController < ApplicationController
  def new
    @comment = Comment.new
    @valuation_url = ValuationUrl.find(params[:id])
    @appraisal = @valuation_url.appraisal
    @organization = @appraisal.organization

    authorize @comment
  end

  def create
    @valuation_url = ValuationUrl.find(params[:id])
    @comment = Comment.new(comment: valuation_url_comment_params[:comment], commentable_id: params[:id], commentable_type: "ValuationUrl", user_id: current_user.id)
    @comment.save

    authorize @comment
  end


  def show
    @comments = Comment
      .where(commentable_type: "ValuationUrl", commentable_id: params[:id])
    @valuation_url = ValuationUrl.find(params[:id])
    @appraisal = @valuation_url.appraisal

    authorize @comments
  end

  private

  def valuation_url_comment_params
    params
      .require(:comment)
      .permit(:comment)
  end


end
