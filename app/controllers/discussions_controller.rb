class DiscussionsController < ApplicationController
  def create
    @discussion = Discussion.new(
      name: discussion_params[:name],
      appraisal_id: params[:appraisal_id]
    )
    @discussion.save
    @discussion.comments.create!(
      commentable_type: "Discussion",
      commentable_id: @discussion.id,
      comment: discussion_params["comments_attributes"]["0"]["comment"],
      user_id: current_user.id
    )

    @appraisal = Appraisal.find(params[:appraisal_id])
    @organization = Organization.find(params[:organization_id])

    authorize @discussion
  end

  def show
    @appraisal = Appraisal.find(params[:appraisal_id])
    @organization = Organization.find(params[:organization_id])

    @discussions = Discussion
      .where(appraisal_id: @appraisal.id)
    @discussion = Discussion.new
    @discussion.comments.build

    authorize @discussion
  end

  private

  def discussion_params
    params
      .require(:discussion)
      .permit(:name, comments_attributes: [:comment])
  end
end
