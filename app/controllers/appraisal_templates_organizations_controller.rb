class AppraisalTemplatesOrganizationsController < ApplicationController
  skip_after_action :verify_authorized

  def update_ato_visibility
    ato = AppraisalTemplatesOrganization.find_by(id: params[:id])
    ato.update_attribute(:is_visible,params[:is_visible].to_s == "true") if ato
    render text:  ato.try(:is_visible)
  end

end
