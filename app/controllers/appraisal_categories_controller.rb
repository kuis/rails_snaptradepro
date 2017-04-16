class AppraisalCategoriesController < ApplicationController
  skip_after_action :verify_authorized

  def show
    category = AppraisalCategory.find(params[:id])
    template_fields = category.template_fields

    render json: template_fields, root: false
  end
end
