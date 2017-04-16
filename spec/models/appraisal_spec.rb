require 'spec_helper'

describe Appraisal do
  describe "associations" do
    it { should belong_to :appraisal_template }
    it { should belong_to :customer }
    it { should belong_to :user }
    it { should belong_to :organization }
    it { should have_many :appraisal_entries }
  end

  describe "validations" do
    it { should validate_presence_of :appraisal_template }
    it { should validate_presence_of :user }
    it { should validate_presence_of :organization }
    it { should validate_presence_of(:name).with_message('Please enter name.') }
    it { should validate_presence_of(:customer_id).with_message('Please select or create customer.') }
  end

  context 'self methods' do
    context '.clone' do
      before (:each) do
        @appraisal = FactoryGirl.create(:appraisal)
        @cloned = Appraisal.clone(@appraisal)
      end

      it "should clone current appraisal" do
        expect(@cloned.name).to                   eq("Cloned - #{@appraisal.name}")
        expect(@cloned.status).to                 eq(@appraisal.status)
        expect(@cloned.user_id).to                eq(@appraisal.user_id)
        expect(@cloned.customer_id).to            eq(@appraisal.customer_id)
        expect(@cloned.organization_id).to        eq(@appraisal.organization_id)
        expect(@cloned.appraisal_template_id).to  eq(@appraisal.appraisal_template_id)
      end

      it "should clone current appraisal's entries" do
        expect(@cloned.appraisal_entries.count).to eq(@appraisal.appraisal_entries.count)
      end

      it "should set cloned appraisal's unit to nil" do
        expect(@cloned.unit).to be_nil
      end
    end
  end

  describe "friendly url slug" do
    it "Should be unique for each record " do
      appraisal1 = FactoryGirl.create(:appraisal)
      appraisal2 = FactoryGirl.create(:appraisal)
      expect(appraisal1.slug).not_to be_nil
      expect(appraisal2.slug).not_to be_nil
      expect(appraisal1.slug).not_to eq appraisal2.slug
    end
  end

end
