require "spec_helper"

describe Api::V1::OrganizationsController do
  default_version 1

  describe "#index" do
    let(:current_user) { create(:user) }

    before do
      controller.stub(current_user: current_user)
    end

    it "returns all appraisals" do
      org1 = create(:organization)
      org2 = create(:organization)
      org3 = create(:organization)

      current_user.organizations << [org1, org2]

      get :index
      expect(response).to have_exposed Organization.where(id: [org1.id, org2.id])
    end

    it "outputs customers and templates" do
      org = create(:organization)
      org.customers << create(:customer)
      org.appraisal_templates << create(:appraisal_template)
      current_user.organizations << [org]

      get :index

      customers = parsed_response.first["customers"]
      templates = parsed_response.first["appraisal_templates"]
      expect(customers.first["account_name"]).to eq org.customers.first.account_name
      expect(templates.first["label"]).to eq org.appraisal_templates.first.label
    end
  end
end
