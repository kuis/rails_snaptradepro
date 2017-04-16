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

  it "allows appraisals to be cloned" do
    visit root_path

    expect(page).to have_text appraisal.name
    click_link appraisal.number
    within ".actions-top" do
      click_button "Clone Appraisal"
      fill_in "number_of_clones", with: 2
      click_button "Go!"
    end
    expect(page).to have_text "2 appraisal(s) cloned."

    expect(page).to have_text "Cloned - #{appraisal.name}"
  end

  it "requires the number of clone" do
    visit root_path

    expect(page).to have_text appraisal.name
    click_link appraisal.number
    within ".actions-top" do
      click_button "Clone Appraisal"
      fill_in "number_of_clones", with: nil
      click_button "Go!"
    end
    expect(page).to have_text "Please enter the number of clones"
  end

  it "denies the number of clone which is out of range(1 ~ 99)" do
    visit root_path

    expect(page).to have_text appraisal.name
    click_link appraisal.number
    within ".actions-top" do
      click_button "Clone Appraisal"
      fill_in "number_of_clones", with: 120
      click_button "Go!"
    end
    expect(page).to have_text "Number of clones must be in range of 1 ~ 99"
  end
end
