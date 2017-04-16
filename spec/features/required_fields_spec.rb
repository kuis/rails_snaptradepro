require "spec_helper"

describe "appraisals" do
  let(:user) { create(:user, :logged_in) }
  let(:heavy_truck_template) { create(:appraisal_template) }
  let(:organization) do
    create(:organization, appraisal_templates: [heavy_truck_template],
                          users: [user])
  end
  let!(:customer) { create(:customer, organization: organization) }

  before do
    heavy_truck_template.appraisal_categories << create(:required_fields_category)
    visit new_organization_appraisal_path(organization, appraisal_template_id: heavy_truck_template.id)
  end

  it "allows creation of appraisals" do
    click_first_submit "Create Appraisal"
    within find("div.form-group", text: "Required Text Field") do
      expect(page).to have_text "can't be blank"
    end
  end
end
