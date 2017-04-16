require "spec_helper"

describe "appraisal history" do
  let(:user) { create(:user, :logged_in) }
  let!(:appraisal) { create(:appraisal) }
  let!(:membership) do 
    create(:membership, user: user, 
                        organization: appraisal.organization, 
                        active: true, 
                        invitation_accepted_at: Time.now)
  end

  it "keeps a history of changes" do
    visit root_path
    click_link appraisal.number

    click_first_link "Edit Appraisal"
    fill_in "Mileage", with: "90000"
    click_first_submit "Update Appraisal"

    click_first_link "Edit Appraisal"
    fill_in "Mileage", with: "6000"
    click_first_submit "Update Appraisal"

    find(".history-link").click
    expect(page).to have_text("History of changes for Mileage")
    expect(page).to have_text("90000")
    expect(page).to have_text(user.name)
  end

  it "keeps a history changes to images" do
    visit root_path
    click_link appraisal.number

    click_first_link "Edit Appraisal"
  end
end
