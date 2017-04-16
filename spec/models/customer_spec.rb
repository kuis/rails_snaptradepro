require "spec_helper"

describe Customer do
  describe "associations" do
    it { should belong_to :organization }
    it { should have_many :appraisals }
  end

  describe "validations" do
    it { should validate_presence_of :organization }
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
    it { should validate_presence_of :account_name }
    it { should validate_presence_of :business_phone }
  end
end
