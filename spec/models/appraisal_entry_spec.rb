require 'spec_helper'

describe AppraisalEntry do
  describe "associations" do
    it { should belong_to :appraisal }
    it { should belong_to :template_field }
  end

  describe "validations" do
    it { should validate_presence_of :template_field }
  end

  describe "#adjust_last6_and_last7" do
    before do
      @serial_no_field = FactoryGirl.create(:serial_no_field, :has_effect_on_other_fields => true)
      @last6_field = FactoryGirl.create(:last6_field)
      @last8_field = FactoryGirl.create(:last8_field)
      @appraisal = FactoryGirl.create(:appraisal)
    end
    it "Should set last6 and last8 when serial no is greater than 8 characters" do
      create_serial_no_appraisal_entry('1234567890')
      fetch_last6_and_last8
      expect(@last6_appraisal_entry).not_to be_nil
      expect(@last8_appraisal_entry).not_to be_nil

      expect(@last6_appraisal_entry.value.length).to eq(6)
      expect(@last8_appraisal_entry.value.length).to eq(8)

      expect(@last6_appraisal_entry.value).to eq('567890')
      expect(@last8_appraisal_entry.value).to eq('34567890')

    end
    it "Should set last6 but not last8 when serial no is greater or equal to 6 but less than 8 characters" do
      create_serial_no_appraisal_entry('1234567')
      fetch_last6_and_last8
      expect(@last6_appraisal_entry.value.to_s.length).to eq(6)
      expect(@last8_appraisal_entry.value.to_s.length).to eq(0)
      expect(@last6_appraisal_entry.value).to eq('234567')
    end
    it "Should clear last6 and last8 when serial no is less than 6 characters" do
      create_serial_no_appraisal_entry('123')
      fetch_last6_and_last8
      expect(@last6_appraisal_entry.value.to_s.length).to eq(0)
      expect(@last8_appraisal_entry.value.to_s.length).to eq(0)
    end

    it "Should update last6 and last 8 once serial no gets changed" do
      serial_no_appraisal_entry = create_serial_no_appraisal_entry('987654321')
      serial_no_appraisal_entry.update_attribute(:value, 'ABCDEFGHIJKLMNOP')
      fetch_last6_and_last8
      expect(@last6_appraisal_entry.value).not_to be_nil
      expect(@last8_appraisal_entry.value).not_to be_nil
      expect(@last6_appraisal_entry.value).to eq('KLMNOP')
      expect(@last8_appraisal_entry.value).to eq('IJKLMNOP')
    end
  end
end

def create_serial_no_appraisal_entry(serial_no)
  FactoryGirl.create(:appraisal_entry,:value => serial_no, :template_field => @serial_no_field, :appraisal => @appraisal)
end

def fetch_last6_and_last8
  @last6_appraisal_entry = AppraisalEntry.where("appraisal_id=? AND template_field_id=?", @appraisal.id, @last6_field.id).first
  @last8_appraisal_entry = AppraisalEntry.where("appraisal_id=? AND template_field_id=?", @appraisal.id, @last8_field.id).first
end


