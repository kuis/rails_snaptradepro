class OrganizationEquipmentTypesController < ApplicationController
  skip_after_action :verify_authorized

  def update_oet_user_creatable
    oet = OrganizationEquipmentType.find_by(id: params[:id])
    oet.update_attribute(:user_creatable,params[:user_creatable].to_s == "true") if oet
    render text:  oet.try(:user_creatable)
  end

end
