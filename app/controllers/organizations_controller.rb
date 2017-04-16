class OrganizationsController < ApplicationController

  def show
    authorize @organization
    @members = @organization.users.invitation_accepted
  end

  def update
    authorize @organization
    @organization.update(organization_params)
    if params[:organization][:users_attributes]
      redirect_to organization_members_path(@organization), notice: "Members updated"
    else
      redirect_to @organization, notice: "Organization updated"
    end
  end

  private

  def organization_params
    whitelisted = params.require(:organization).permit(
      :trade_name,
      :street_address,
      :city,
      :email,
      :state,
      :zipcode,
      :call_to_action,
      :sale_sheet_phone,

      :toll_free,
      :main,
      :sales,
      :mobile_phone,
      :service,
      :parts,
      :commentary,
      :warranty,
      :location,
      :sale_term_conditions,
      :term_guidelines,
      :company_logo,
      :map_image,
      :users_attributes => [
        :id,
        :_destroy,
        :memberships_attributes => [:id, :role_id, :active, :_destroy]
      ]
    )
    whitelisted[:setting] = params[:organization][:setting].permit! if params[:organization][:setting]
    whitelisted
  end
end
