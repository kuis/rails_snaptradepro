class Api::V1::AppraisalCategoriesController < Api::V1::BaseController
  version 1

  def show
    appraisal = Appraisal.find(params[:appraisal_id])
    authorize appraisal

    category = appraisal.appraisal_template.appraisal_categories.find(params[:id])
    AppraisalCategorySerializer.root = false
    category = AppraisalCategorySerializer.new(category, appraisal: appraisal)
    category.include_fields = true

    expose category.as_json
  end
end
