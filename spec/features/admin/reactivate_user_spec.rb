require 'spec_helper'

describe 'reactivate user' do
  let!(:admin) { create(:user, :logged_in, admin: true) }
  let!(:user)  { create(:user) }
  let!(:membership) { create(:membership, user: user, active: true) }

  before do
    visit edit_admin_user_path(user)
  end

  it "deactivates all memberships when the user is de-activated" do
    uncheck 'user_active'
    click_button "Update User"

    expect(user.memberships.pluck(:active).any?).to be_falsy
  end

  it "sends reactivate notification when the user is reactivated" do
    user.active = false
    user.save
    user.memberships.first.update(active: true)

    check 'user_active'
    click_button "Update User"
    email = open_email(user.email)
    email.should have_body_text("Your Snap Trade Pro account has been reactivated")
  end

  it "validates membership activeness when the user is reactivated" do
    user.memberships << FactoryGirl.create(:membership, user: user, active: false)

    user.active = false
    user.save

    check 'user_active'
    click_button "Update User"

    expect(user.active?).to be_falsy
    within find("li", text: "Active") do
      expect(page).to have_text "There are no active memberships"
    end
  end
end
