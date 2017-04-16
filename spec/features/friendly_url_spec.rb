require "spec_helper"

describe "friendly url" do

  let!(:user) { create(:user, :logged_in, admin: true) }
  let!(:admin) { create(:user, admin: true) }

  let(:organization) { create(:organization) }
  let(:appraisal) { create(:appraisal, :organization_id => organization.id) }

  describe "appraisal" do
    it "show should have url with organization and appraisal slug instead of their IDs" do
      visit organization_appraisal_path(organization, appraisal)
      expect(current_url.split('/')[-1]).to eq(appraisal.slug)
      expect(current_url.split('/')[-3]).to eq(organization.slug)
    end
    it "index should have url with organisation slug instead of it's ID" do
      visit organization_appraisals_path(organization)
      expect(current_url.split('/')[-2]).to eq(organization.slug)
    end
  end

end
