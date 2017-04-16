require 'spec_helper'

describe 'organization creation' do
  let!(:user) { create(:user, :logged_in, admin: true) }
  let!(:admin) { create(:user, admin: true) }
  let!(:owner) { create(:user, admin: true) }

  before do
    visit new_admin_organization_path
  end

  it "doesn't create organization if admin or owner is invalid" do
    fill_in "Name", with: "Ryan's Organization"
    fill_in "Acronym", with: "AAA"
    click_button "Create Organization"

    within find("li#organization_admin_input") do
      expect(page).to have_text "can't be blank"
    end
    within find("li#organization_owner_input") do
      expect(page).to have_text "can't be blank"
    end
  end

  it "sends an notification to admin and owner" do
    fill_in "Name", with: "Ryan's Organization"
    fill_in "Acronym", with: "AAA"
    select owner.name, from: "Owner"
    select admin.name, from: "Admin"
    click_button "Create Organization"

    email = open_email(owner.email)
    expect(email.subject).to eq("Your are an organization owner for Ryan's Organization")

    email = open_email(admin.email)
    expect(email.subject).to eq("Your are an organization admin for Ryan's Organization")
  end
end
