require "spec_helper"

describe Api::V1::CustomersController do
  default_version 1

  before do
    current_user = create(:user, admin: true)
    controller.stub(current_user: current_user)
  end

  describe "#create" do
    let!(:organization) { create(:organization) }

    it "allows customer to be created" do
      post :create, organization_id: organization.id,
                    customer: { account_name: "Jim's autos",
                                first_name: "Jim", last_name: "Kerry",
                                business_phone: "7773332233" }

      expect(response).to have_exposed(Customer.first)
    end

    it "rejects invalid appraisal" do
      post :create, organization_id: organization.id,
                    customer: { account_name: "Jim's autos",
                                first_name: "Jim",
                                business_phone: "7773332233" }

      expect(response).to be_api_error(RocketPants::InvalidResource)
      expect(parsed_body["messages"]["last_name"].first).to eq "can't be blank"
    end
  end

  describe "#show" do
    let!(:organization) { create(:organization) }
    let!(:customer) { create(:customer, organization: organization) }

    it "returns a customer by id" do
      get :show,
        organization_id: organization.id,
        id: customer.id

      expect(response).to have_exposed(customer)
    end
  end

  describe "#update" do
    let!(:organization) { create(:organization) }
    let!(:customer) { create(:customer, organization: organization) }

    it "updates existing user with new params" do
      new_params = {
        business_phone: "123-457-1234"
      }

      put :update,
        organization_id: organization.id,
        id: customer.id,
        customer: new_params

      expect(response).to have_exposed(Customer.first)
    end

    it "rejects invalid customer" do
      put :update,
        organization_id: organization.id,
        id: customer.id,
        customer: { first_name: "" }

      expect(response).to be_api_error(RocketPants::InvalidResource)
      expect(parsed_body["messages"]["first_name"].first).to eq "can't be blank"
    end
  end
end
