require "spec_helper"

describe AppraisalTemplate do
  describe "associations" do
    it { should have_and_belong_to_many :appraisal_categories }
    it { should have_and_belong_to_many :organizations }
  end

  describe "validations" do
    it { should validate_presence_of :label }
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
  end

  context 'self methods' do
    context '.clone' do
      before (:each) do
        @appraisal_template = FactoryGirl.create(:appraisal_template)
        @cloned = AppraisalTemplate.clone(@appraisal_template)
      end

      it "should clone current appraisal" do
        expect(@cloned.name).to                       eq("Cloned - #{@appraisal_template.name} #{AppraisalTemplate.count - 1}")
        expect(@cloned.organizations.size).to         eq(@appraisal_template.organizations.size)
        expect(@cloned.appraisal_categories.size).to  eq(@appraisal_template.appraisal_categories.size)
      end
    end
  end
end
