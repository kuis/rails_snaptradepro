require "spec_helper"

describe "admin users" do
  let!(:admin) { create(:user, :logged_in, admin: true) }
  let!(:user) { create(:user) }
  let!(:membership) { create(:membership, user: user, active: true) }

  before do
    visit edit_admin_user_path(user)
  end

  it "should be able to archive user" do
    check 'user_archived'
    click_button "Update User"

    visit admin_users_path(scope: 'archived')
    expect(page).to have_text user.name
  end
end
