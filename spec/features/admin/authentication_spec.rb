require "spec_helper"

describe "admin panel" do
  it "allows login if user is an admin" do
    user = create(:user, :logged_in, admin: true)

    visit admin_root_path

    expect(page).to have_text "Organizations"
    expect(page).to have_text "Users"
    expect(current_url).to include "admin"
  end

  it "redirects if user is not admin" do
    create(:user, :logged_in)

    visit admin_root_path
    expect(current_path).to eq "/"
  end
end
