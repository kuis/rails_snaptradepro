require "spec_helper"

describe "invitations" do
  it "allows invitation to be accepted" do
    User.invite!(email: "test@example.com")

    email = open_email("test@example.com")
    email.should have_body_text("You are invited to Snap Trade Pro")
    visit_in_email "Accept invitation"

    expect(page).to have_text "Create Your Account"

    fill_in "First name", with: "Ryan"
    fill_in "Last name", with: "Boland"

    click_button "Create your account"
    expect(page).to have_text "can't be blank"

    fill_in "Password", with: "test_password"
    fill_in "Password confirmation", with: "test_password"

    click_button "Create your account"

    expect(page).to have_text "Your password was set"
  end
end
