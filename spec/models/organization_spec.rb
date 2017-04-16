require "spec_helper"

describe Organization do
  describe "associations" do
    it { should have_many :customers }
    it { should have_many :appraisals }
    it { should have_many(:users).through(:memberships) }
    it { should have_many(:memberships) }
    it { should have_many :appraisal_templates }
    it { should belong_to(:owner).class_name('User').with_foreign_key('owner_id') }
    it { should belong_to(:admin).class_name('User').with_foreign_key('admin_id') }
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :acronym }
    it { should validate_presence_of :owner }
    it { should validate_presence_of :admin }
    it { should allow_value("AZT").for(:acronym) }
    it { should allow_value("JFK").for(:acronym) }
    it { should allow_value("MET").for(:acronym) }
    it { should_not allow_value("AZ").for(:acronym) }
    it { should_not allow_value("AZAF").for(:acronym) }
    it { should_not allow_value("011").for(:acronym) }
    it { should_not allow_value("adf").for(:acronym) }
  end

  describe "friendly url slug" do
    it "Should be unique for each record " do
      organization1 = FactoryGirl.create(:organization)
      organization2 = FactoryGirl.create(:organization)
      organization3 = FactoryGirl.create(:organization, :acronym => "ABC")
      expect([organization1.slug,organization2.slug,organization3.slug].compact.uniq.count).to eq(3)
    end
  end
end
