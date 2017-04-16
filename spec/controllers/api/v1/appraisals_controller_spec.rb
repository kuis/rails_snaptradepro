require "spec_helper"

describe Api::V1::AppraisalsController do
  default_version 1

  before do
    current_user = create(:user, admin: true)
    controller.stub(current_user: current_user)
  end

  describe "#index" do
    it "returns all appraisals" do
      customer1 = create(:customer)
      create_list(:appraisal, 3, customer: customer1)
      customer2 = create(:customer)
      create_list(:appraisal, 2, customer: customer2)

      get :index

      customer1_appraisals = parsed_response[customer1.account_name]
      customer2_appraisals = parsed_response[customer2.account_name]

      expect(customer1_appraisals.count).to eq 3
      expect(customer2_appraisals.count).to eq 2

      # expose just organization id
      expect(customer1_appraisals.first["organization"]["id"]).to eq customer1.appraisals.first.organization.id

      # exposes user
      expect(customer1_appraisals.first["user"]).to be_present

      # doesn't expose template
      expect(customer1_appraisals.first["appraisal_template"]).to be_nil
    end

    it "returns on relevant appraisal as non-admin" do
      org1 = create(:organization)
      org2 = create(:organization)

      current_user = create(:user)
      current_user.organizations << [org1]
      controller.stub(current_user: current_user)

      customer1 = create(:customer, organization: org1)
      create_list(:appraisal, 1, customer: customer1, organization: org1)

      customer2 = create(:customer, organization: org2)
      create_list(:appraisal, 1, customer: customer2, organization: org2)

      get :index

      expect(parsed_response).to have_key customer1.account_name
      expect(parsed_response).to_not have_key customer2.account_name
    end
  end

  describe "#show" do
    let(:customer) { create(:customer) }
    let(:appraisal) { create(:appraisal, customer: customer) }

    it "returns the appraisal" do
      get :show, id: appraisal.id, organization_id: appraisal.organization.id

      expect(parsed_response["name"]).to eq appraisal.name
      expect(parsed_response["status"]).to be_a Hash
      expect(parsed_response["status"]["value"]).to eq "Assessment"
      expect(parsed_response["organization"]["id"]).to eq appraisal.organization.id
      expect(parsed_response["appraisal_template"]["label"]).to eq appraisal.appraisal_template.label
      expect(parsed_response["appraisal_template"]).to have_key("appraisal_categories")
      expect(parsed_response["categories"]).to_not be_present
    end

    it "returns the appraisals customer" do
      get :show, id: appraisal.id, organization_id: appraisal.organization.id

      expect(parsed_response["customer"]["id"]).to eq(customer.id)
      expect(parsed_response["customer"]["first_name"]).to eq(customer.first_name)
      expect(parsed_response["customer"]["last_name"]).to eq(customer.last_name)
    end

    it "has option to include complete category info" do
      category = create(:powertrain_category)
      appraisal.appraisal_template.appraisal_categories = [category]
      appraisal.set_field_value(category.template_fields.first.id, "completed")
      appraisal.save_fields

      get :show, id: appraisal.id, organization_id: appraisal.organization.id,
                                   complete_categories: true

      expect(parsed_response["name"]).to eq appraisal.name
      expect(parsed_response["organization"]["id"]).to eq appraisal.organization.id
      category = parsed_response["categories"].first
      expect(category["fields"].values.count).to eq 1
      expect(category["fields"].values.first["value"]).to eq "completed"
    end
  end

  describe "#create" do
    let!(:template) { create(:appraisal_template) }
    let!(:organization) { create(:organization) }
    let!(:customer) { create(:customer) }

    before do
      organization.appraisal_templates << template
    end

    it "allows appraisal to be created" do
      post :create, organization_id: organization.id,
                    appraisal: { appraisal_template_id: template.id,
                                 customer_id: customer.id,
                                 name: "an appraisal name" }
      expect(response).to have_exposed(Appraisal.first)
    end

    it "rejects invalid appraisal" do
      post :create, organization_id: organization.id,
                    appraisal: { appraisal_template_id: template.id,
                                 name: "an appraisal name" }

      expect(response).to be_api_error(RocketPants::InvalidResource)
      expect(parsed_body["messages"]["customer_id"].first).to eq "Please select or create customer."
    end

    it "does NOT enforce required fields" do
      template.appraisal_categories << create(:required_fields_category)

      post :create, organization_id: organization.id,
                    appraisal: { appraisal_template_id: template.id,
                                 customer_id: customer.id,
                                 name: "an appraisal name" }
      expect(response).to have_exposed(Appraisal.first)
    end
  end

  describe "#update" do
    let(:customer) { create(:customer) }
    let(:appraisal) { create(:appraisal, customer: customer) }

    before do
    end

    it "allows appraisal to be updated" do
      put :update, id: appraisal.id,
                   organization_id: appraisal.organization.id,
                   appraisal: { name: "a different name" }

      expect(response).to have_exposed(Appraisal.first)
    end

    it "rejects invalid appraisal" do
      put :update, id: appraisal.id,
                   organization_id: appraisal.organization.id,
                   appraisal: { name: "" }

      expect(response).to be_api_error(RocketPants::InvalidResource)
      expect(parsed_body["messages"]["name"].first).to eq "Please enter name."
    end

    it "enforces required fields" do
      skip "decide what to do with required fields"

      appraisal.appraisal_template.appraisal_categories << create(:required_fields_category)

      put :update, id: appraisal.id,
                   organization_id: appraisal.organization.id,
                   appraisal: { name: "a new name" }

      expect(response).to be_api_error(RocketPants::InvalidResource)
      expect(parsed_body["messages"]["required text field"].first).to eq "can't be blank"
    end
  end
end
