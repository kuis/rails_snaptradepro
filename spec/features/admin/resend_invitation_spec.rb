require 'spec_helper'

describe 'resend_invitation' do
  let!(:admin) { create(:user, :logged_in, admin: true) }
  let!(:user)  { create(:user) }

  before do
    visit admin_user_path(user)
  end

  it "sends invitation email again" do
    click_link "Resend Invitation"

    email = open_email(user.email)
    email.should have_body_text("You are invited to Snap Trade Pro where you")
  end
end
