require 'spec_helper'

describe TemplateField do
  describe "associations" do
    it { should have_and_belong_to_many :appraisal_categories }
  end

  describe "validations" do
    before do
      create(:id_field)
    end

    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
    it { should validate_presence_of :label }
    it { should validate_presence_of :field_type }
  end

  describe "#display_attribute" do
    let(:organization) { FactoryGirl.create(:organization) }
    let(:template_field) { FactoryGirl.create(:last6_field, print_label: "Last 6") }

    before(:each) do
      field_access_control = FactoryGirl.create(:field_access_control, organization_id: organization.id, template_field_id: template_field.id)
      field_access_control.label = "custom-label"
      field_access_control.print_label = "custom-print-label"
      field_access_control.save
    end

    it "should return attribute based on Organization specified" do
      template_field.display_attribute(organization,:label).should == "custom-label"
      template_field.display_attribute(organization,:print_label).should == "custom-print-label"
    end
    it "should return default attribute if Organization is not present" do
      template_field.display_attribute(nil,:label).should == "Last6"
      template_field.display_attribute(nil,:print_label).should == "Last 6"
    end
  end

  describe "#showable?" do
    before(:each) do
      @organization = FactoryGirl.create(:organization)
      @user = FactoryGirl.create(:org_member, :logged_in, current_organization: @organization)
      @mileage_field = FactoryGirl.create(:mileage_field)
    end
    it "should return true while there is no FAC created yet for the Org with the template field" do
      @mileage_field.showable?(:view,@organization,@user).should == true
    end

    it "should return false while the fac is created but access has not been given yet" do
      @field_access_control = FactoryGirl.create(:field_access_control,organization: @organization, template_field: @mileage_field)
      @mileage_field.showable?(:view,@organization,@user).should == false
    end

    it "should return true while the fac is created and access has been given for that field" do
      @field_access_control = FactoryGirl.create(:field_access_control,organization: @organization, template_field: @mileage_field, view_permission: @user.roles.map(&:id).join(",") )
      @mileage_field.showable?(:view,@organization,@user).should == true
    end
    it "should return true while the fac is created for other Org" do
      @organization2 = FactoryGirl.create(:organization)
      @field_access_control = FactoryGirl.create(:field_access_control,organization: @organization2, template_field: @mileage_field, view_permission: @user.roles.map(&:id).join(",") )
      @mileage_field.showable?(:view,@organization,@user).should == true
    end
  end

end
