require "spec_helper"

describe Api::V1::AppraisalCategoriesController do
  default_version 1

  before do
    current_user = create(:user, admin: true)
    controller.stub(current_user: current_user)
  end

  describe "#show" do
    let(:customer) { create(:customer) }
    let(:appraisal) { create(:appraisal, customer: customer) }

    # pick out the powertrain category from factory
    let(:category) { appraisal.appraisal_template.appraisal_categories.find_by(label: "Powertrain") }

    let(:numeric_field) { category.template_fields.find_by(field_type: "Numeric") }
    let(:select_field) { category.template_fields.find_by(field_type: "Select") }

    it "returns the category" do
      get :show, id: category.id, appraisal_id: appraisal.id

      expect(parsed_response["id"]).to eq category.id
      expect(parsed_response["fields"][numeric_field.id.to_s]["label"]).to eq numeric_field.label
    end

    it "returns the weight" do
      numeric_field.weight = 80
      numeric_field.save

      get :show, id: category.id, appraisal_id: appraisal.id

      expect(parsed_response["fields"][numeric_field.id.to_s]["weight"]).to eq 80
      expect(parsed_response["fields"][select_field.id.to_s]["weight"]).to eq 50
    end

    it "returns the required status" do
      numeric_field.required = true
      numeric_field.save

      get :show, id: category.id, appraisal_id: appraisal.id

      expect(parsed_response["fields"][numeric_field.id.to_s]["required"]).to eq true
      expect(parsed_response["fields"][select_field.id.to_s]["required"]).to eq false
    end

    it "returns the choices, if applicable" do
      get :show, id: category.id, appraisal_id: appraisal.id

      expect(parsed_response["id"]).to eq category.id
      expect(parsed_response["fields"][numeric_field.id.to_s]).to_not have_key "choices"
      expect(parsed_response["fields"][select_field.id.to_s]["choices"]).to match_array select_field.choices_array
    end

    it "returns formatting if applicable" do
      get :show, id: category.id, appraisal_id: appraisal.id

      expect(parsed_response["id"]).to eq category.id
      expect(parsed_response["fields"][numeric_field.id.to_s]["formatting"]).to eq numeric_field.formatting
      expect(parsed_response["fields"][select_field.id.to_s]).to_not have_key "formatting"
    end

    it "returns the value" do
      appraisal.set_field_value(numeric_field.id, 455_000)
      appraisal.save

      get :show, id: category.id, appraisal_id: appraisal.id

      expect(parsed_response["fields"][numeric_field.id.to_s]["value"]).to eq 455_000
    end
  end
end
