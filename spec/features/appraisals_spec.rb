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
    visit new_organization_appraisal_path(organization, appraisal_template_id: heavy_truck_template.id)
  end

  it "allows creation of appraisals" do
    create_appraisal

    expect(page).to have_text "Appraisal created"
    expect(page).to_not have_text "Mileage 120,000.0"
    expect(page).to have_text "Mileage 120,000"
    expect(page).to have_text "Number ANA-000001"
    expect(page).to have_text "Sale Type Dealer"
  end

  it "allows editing of appraisals" do
    create_appraisal

    click_first_link "Edit Appraisal"

    fill_in "Mileage", with: "90000"
    click_first_submit "Update Appraisal"

    expect(page).to have_text "Appraisal updated"
    expect(page).to have_text "Mileage 90,000"
    expect(page).to have_text "Number ANA-000001"
  end

  it "doesn't conflict with other appraisals" do
    create_appraisal

    visit new_organization_appraisal_path(organization, appraisal_template_id: heavy_truck_template.id)

    fill_in "Name", with: "My Appraisal"
    fill_in "Mileage", with: "80000"
    select "Bank", from: "Sale Type"
    select customer.account_name, from: "Customer"

    click_first_submit "Create Appraisal"

    expect(page).to have_text "Appraisal created"
    expect(page).to have_text "Mileage 80,000"
    expect(page).to have_text "Number ANA-000002"
    expect(page).to have_text "Sale Type Bank"

    visit organization_appraisals_path(organization)

    within find("tr", text: "ANA-000001") do
      click_link "ANA-000001"
    end

    expect(page).to have_text "Mileage 120,000"
    expect(page).to have_text "Number ANA-000001"
  end

  it "allows customers to be added on the fly", js: true do
    click_link "Create Customer"
    fill_in "Account name", with: "Watson Electric"
    fill_in "First name", with: "Ryan"
    fill_in "Last name", with: "Boland"
    fill_in "Business phone", with: "777 443 1321"
    click_button "Create Customer"

    select = find("#appraisal_customer_id")
    expect(select).to have_text("Ryan Boland")
    expect(select.value).to eq Customer.find_by(last_name: "Boland").id.to_s
  end

  def create_appraisal
    select customer.account_name, from: "Customer"
    fill_in "Name", with: "My Appraisal"

    expect(page).to have_text "Powertrain"
    fill_in "Mileage", with: "120000"
    fill_in "Engine Condition", with: "It's in good condition"

    expect(page).to have_text "Unit Identification"
    select "Dealer", from: "Sale Type"

    click_first_submit "Create Appraisal"
  end
end
