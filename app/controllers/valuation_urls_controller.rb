class ValuationUrlsController < ApplicationController
  def create
    @valuation_url = ValuationUrl.new(
      valuation_url_params.merge({ user_id: current_user.id, appraisal_id: params[:appraisal_id] }))
    @valuation_url.save

    @appraisal = Appraisal.find(params[:appraisal_id])
    @organization = Organization.find(params[:organization_id])

    authorize @valuation_url
  end

  def show
    @appraisal = Appraisal.find(params[:appraisal_id])
    @organization = Organization.find(params[:organization_id])

    @valuation_urls = ValuationUrl
      .where(appraisal_id: @appraisal.id)
    @valuation_url = ValuationUrl.new

    authorize @valuation_url
  end

  private

  def valuation_url_params
    params
      .require(:valuation_url)
      .permit(:url, :year, :make, :model, :retail_value, :wholesale_value)
  end
end
