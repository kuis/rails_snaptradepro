require "spec_helper"

describe "Customers" do
  let!(:user) { create(:user, :logged_in) }
  let(:organization) { create(:organization) }

  before do
    organization.users << user

    visit organization_customers_path(organization)

    click_link "New Customer"
    fill_in "Account name", with: "Westman Bulk"
    fill_in "First name", with: "Mike"
    fill_in "Last name", with: "Boyle"
    fill_in "Business phone", with: "7244431022"
    within ".actions-top" do
      click_button "Create Customer"
    end
  end

  it "can be created" do
    expect(page).to have_text "created successfully"
    expect(page).to have_text "Westman Bulk"
  end

  it "can be edited" do
    visit organization_customers_path(organization)
    within find("tr", text: "Westman Bulk") do
      click_link "Westman Bulk"
    end
    within ".actions-top" do
      click_link "Edit Customer"
    end
    fill_in "Email", with: "mboyle@westman.com"

    within ".actions-top" do
      click_button "Update Customer"
    end

    expect(page).to have_text "updated successfully"
  end

  # it "can be destroyed" do
  #   visit organization_customers_path(organization)
  #   within find("tr", text: "Westman Bulk") do
  #     click_link "Westman Bulk"
  #   end
  #   click_link "Delete Customer"
  #   expect(page).to have_text "Customer deleted"
  #   expect(page).to_not have_text "Westman Bulk"
  # end

  it "can be viewed" do
    within find("tr", text: "Westman Bulk") do
      click_link "Westman Bulk"
    end
    within ".actions-top" do
      click_link "Edit Customer"
    end
    expect(page).to have_text "Westman Bulk"
  end

  it "displays validation errors" do
    click_link "New Customer"
    fill_in "Account name", with: "Westman Bulk"
    within ".actions-top" do
      click_button "Create Customer"
    end

    expect(page).to have_text "can't be blank"
  end
end
