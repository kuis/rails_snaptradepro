class Api::V1::CustomersController < Api::V1::BaseController
  version 1

  before_action :load_organization, except: [:index]

  def create
    customer = @organization.customers.build(customer_params)
    authorize customer

    if customer.save
      expose customer
    else
      error!(:invalid_resource, customer.errors)
    end
  end

  def update
    customer = @organization.customers.find(params[:id])
    authorize customer

    if customer.update(customer_params)
      expose(customer)
    else
      error!(:invalid_resource, customer.errors)
    end
  end

  def show
    customer = @organization.customers.find(params[:id])
    authorize customer

    expose(customer)
  end

  private

  def customer_params
    params.require(:customer).permit(:account_name, :first_name,
                                     :last_name, :email, :business_phone,
                                     :direct_phone, :street_address,
                                     :city, :state_or_provence, :postal_code, :mobile_phone)
  end

  def load_organization
    @organization = Organization.find(params[:organization_id])
  end
end
