require 'spec_helper'

describe 'clone appraisal category' do
  let!(:user) { create(:user, :logged_in, admin: true) }
  let!(:appraisal_category) { create(:id_category) }

  before do
    visit admin_appraisal_category_path(appraisal_category)
  end

  it "clone current appraisal category" do
    click_link "Clone Category"
    expect(AppraisalCategory.count).to eq(2)

    expect(page).to have_text "Appraisal Category has been cloned"
  end
end
