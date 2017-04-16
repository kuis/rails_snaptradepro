require 'spec_helper'

describe 'organization creation' do
  let!(:user) { create(:user, :logged_in, admin: true) }

  before do
    visit new_admin_user_path
  end

  it "sends an invitation to the user" do
    fill_in "Email", with: "ryan@example.com"
    click_button "Create User"

    expect(page).to have_text "User invited successfully"
    expect(User.count).to eq(2)
    email = open_email("ryan@example.com")
    email.should have_body_text("You are invited to Snap Trade Pro")
  end

  it "doesn't invite the user if email is taken already" do
    fill_in "Email", with: user.email
    fill_in "First name", with: "Ryan"
    fill_in "Last name", with: "Boland"
    click_button "Create User"

    expect(page).to have_text "Email already taken."
    expect(User.count).to eq(1)
    expect(User.last.name).to eq user.name
    expect(all_emails).to eq []
  end
end
