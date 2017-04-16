require "spec_helper"

describe "Pre Launch Registration" do
  before do
    skip "feature removed"

    ENV.stub(:[]).and_call_original
    ENV.stub(:[]).with("PRE_LAUNCH_REGISTRATION_EMAIL")
       .and_return("admin@snaptradepro.com")

    visit root_path
    click_link "Pre Launch Registration"
  end

  context "success" do
    before do
      fill_in "First Name", with: "Ryan"
      fill_in "Last Name", with: "Boland"
      fill_in "Email Address", with: "bolandryanm@gmail.com"
      click_button "Notify"
    end

    it "displays success page" do
      expect(page).to have_text "Thank You!"
      expect(page).to have_text "We will notify you"
    end

    it "sends an email" do
      email = open_email("admin@snaptradepro.com")
      email.should have_body_text("From: Ryan Boland")
      email.should have_body_text("Email: bolandryanm@gmail.com")
      email.should be_delivered_from("bolandryanm@gmail.com")
    end
  end

  context "failure" do
    before do
      fill_in "First Name", with: "Ryan"
      click_button "Notify"
    end

    it "doesn't send" do
      expect(all_emails).to eq []
    end

    it "displays error" do
      expect(page).to have_text "You must complete all of the fields"
    end
  end
end
