require "spec_helper"

describe "customers" do
  let(:user) { create(:user, :logged_in) }
  let!(:customer) { create(:customer) }

  before do
    user.organizations << customer.organization
  end

  it "allows customers to be archived and unarchived" do
    visit organization_customers_path(customer.organization)

    expect(page).to have_text customer.account_name

    within find("tr", text: customer.account_name) do
      click_link customer.account_name
    end

    click_first_link "Archive Customer"
    expect(page).to have_text "Customer archived"
    expect(page).to_not have_text customer.name

    within find("li#customer-link") do
      click_link "Archived"
    end

    expect(page).to have_text customer.account_name

    within find("tr", text: customer.account_name) do
      click_link customer.account_name
    end

    click_first_link "Un-archive Customer"
    expect(page).to have_text "Customer un-archived"

    visit organization_customers_path(customer.organization)
    expect(page).to have_text customer.name
  end
end

