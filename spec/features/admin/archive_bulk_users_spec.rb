require "spec_helper"

describe "admin users" do
  let!(:admin) { create(:user, :logged_in, admin: true) }
  let!(:user)  { create(:user) }
  let!(:users) { create_list(:user, 3) }

  before do
    visit admin_users_path
  end

  it "should be able to archive user", js: true do
    users.each do |user|
      find("#batch_action_item_#{user.id}").set(true)
    end

    click_link 'Batch Actions'
    click_link 'Archive Selected'

    expect(page).to have_text "Selected users have been archived successfully."

    expect(User.archived.count).to eq(3)
    visit admin_users_path(scope: 'archived')
  end
end
