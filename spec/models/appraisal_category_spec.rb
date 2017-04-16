require "spec_helper"

describe AppraisalCategory do
  describe "associations" do
    it { should have_and_belong_to_many :template_fields }
    it { should have_and_belong_to_many :appraisal_templates }
  end

  describe "validations" do
    it { should validate_presence_of :label }
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
    it { should validate_numericality_of :weight }
    it { should ensure_inclusion_of(:weight).in_range 0..100 }
  end

  context 'self methods' do
    context '.clone' do
      before (:each) do
        @appraisal_category = FactoryGirl.create(:id_category)
        @cloned = AppraisalCategory.clone(@appraisal_category)
      end

      it "should clone current appraisal category" do
        expect(@cloned.name).to                      eq("Cloned - #{@appraisal_category.name} #{AppraisalCategory.count-1}")
        expect(@cloned.appraisal_templates.size).to  eq(@appraisal_category.appraisal_templates.size)
      end
    end
  end
end
