require "spec_helper"

describe "appraisals" do
  let(:user) { create(:user, :logged_in) }
  let!(:appraisal) { create(:appraisal) }
  let!(:membership) do 
    create(:membership, user: user, 
                        organization: appraisal.organization, 
                        active: true, 
                        invitation_accepted_at: Time.now)
  end

  it "allows appraisals to be archived and unarchived" do
    visit root_path

    expect(page).to have_text appraisal.name
    click_link appraisal.number
    click_first_link "Archive Appraisal"
    expect(page).to have_text "Appraisal archived"
    expect(page).to_not have_text appraisal.name

    within find("li#appraisal-link") do
      click_link "Archived"
    end
    expect(page).to have_text appraisal.name
    click_link appraisal.number
    click_first_link "Un-archive Appraisal"
    expect(page).to have_text "Appraisal un-archived"

    visit root_path
    expect(page).to have_text appraisal.name
  end
end
