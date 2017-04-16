class CustomersController < ApplicationController
  before_action :find_customer, only: [:show, :edit, :update, :destroy, :archive]
  def index
    @customers = @organization.customers.visible
    authorize @customers.first || Customer.new(organization_id: @organization.id)
  end

  def show
    authorize @customer
  end

  def new
    @customer = @organization.customers.build
    authorize @customer
  end

  def create
    @customer = @organization.customers.build(customer_params)
    authorize @customer

    @customer.save

    respond_to do |format|
      format.html do
        if @customer.persisted?
          redirect_to organization_customers_path(@organization),
                      notice: "Customer created successfully."
        else
          render :new
        end
      end
      format.js
    end
  end

  def edit
    authorize @customer
  end

  def update
    authorize @customer

    if @customer.update(customer_params)
      redirect_to organization_customers_path(@organization),
                  notice: "Customer updated successfully."
    else
      render :edit
    end
  end

  def destroy
    authorize @customer

    @customer.destroy
    redirect_to organization_customers_path(@organization),
                notice: "Customer deleted."
  end

  def archived
    @customers = @organization.customers.archived
    authorize @customers.first || Customer.new(organization_id: @organization.id)
  end

  def archive
    authorize @customer
    @customer.update!(archived: archive?)

    if archive?
      redirect_to organization_customers_path(@organization),
                  notice: "Customer archived."
    else
      redirect_to [@organization, @customer],
                  notice: "Customer un-archived."
    end
  end

  def bulk_archive
    if params[:customer_ids].nil?
      authorize Customer.new(organization_id: @organization.id)
      action = archive? ? "archive" : "un-archive"
      redirect_to :back, notice: "Please select customer(s) to #{action}"
    else
      params[:customer_ids].each do |id|
        customer = Customer.find(id)
        authorize customer
        customer.update!(archived: archive?)
      end

      if archive?
        redirect_to organization_customers_path(@organization),
                    notice: "#{params[:customer_ids].size} Customer(s) archived."
      else
        redirect_to archived_organization_customers_path(@organization),
                    notice: "#{params[:customer_ids].size} Customer(s) un-archived."
      end
    end
  end

  private

  def find_customer
    @customer = @organization.customers.find(params[:id])
  end

  def archive?
    !params[:unarchive]
  end

  def customer_params
    params.require(:customer).permit(:account_name, :first_name,
                                     :last_name, :email, :business_phone,
                                     :direct_phone, :street_address,
                                     :city, :state_or_provence, :postal_code,
                                     :mobile_phone)
  end
end
