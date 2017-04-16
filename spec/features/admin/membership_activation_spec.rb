require 'spec_helper'

describe 'membership activation' do
  let!(:admin) { create(:user, :logged_in, admin: true) }
  let!(:org_admin)  { create(:user) }
  let!(:membership) { create(:membership, user: org_admin, active: true) }

  before do
    membership.organization.update(admin: org_admin)
    visit edit_admin_membership_path(membership)
  end

  it "prevents deactivation if the member is an owner or admin" do
    uncheck 'membership_active'
    click_button "Update Membership"

    within find("li#membership_active_input") do
      expect(page).to have_text "Org Owner and Org Admin can't be inactive"
    end
  end
end
