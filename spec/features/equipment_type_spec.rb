require "spec_helper"

describe "equipment type " do

  before(:each) do
    FactoryGirl.create(:user, :logged_in, admin: true)
    @organization = FactoryGirl.create(:organization, is_equipment_type_enabled: true)
    @organization.equipment_types << EquipmentType.all
    FactoryGirl.create(:appraisal, organization_id:  @organization.id)
  end


  describe "appraisal index page  " do
    describe "with et enabled organization" do
      it "should contain all equipment types link at the left nav" do
        visit organization_appraisals_path(@organization)
        expect(page.find("#appraisal-link").text.include?("TA - Trade Appraisal")).to eq true
        expect(page.find("#appraisal-link").text.include?("UI - Used Inventory")).to eq true
        expect(page.find("#appraisal-link").text.include?("NI - New Inventory")).to eq true
      end

      it "should contain equipment types link for the specific organization at the left nav" do
        @organization.equipment_types = EquipmentType.where("name='TA' OR name='UI'")
        @organization.save
        visit organization_appraisals_path(@organization)
        expect(page.find("#appraisal-link").text.include?("TA - Trade Appraisal")).to eq true
        expect(page.find("#appraisal-link").text.include?("UI - Used Inventory")).to eq true
        expect(page.find("#appraisal-link").text.include?("NI - New Inventory")).to eq false
      end

      describe "click on trade appraisals link from left nav" do
        it "should load all the trade appraisals " do
          visit organization_appraisals_path(@organization)
          page.find("li#appraisal-link a", text: "TA - Trade Appraisal").click()
          page.all('table#datatable_fixed_column tbody tr').count.should == 1
        end
        it "should render appropriate create button " do
          visit organization_appraisals_path(@organization)
          page.find("li#appraisal-link a", text: "TA - Trade Appraisal").click()
          page.all("button.create_btn", text:"Create New TA - Trade Appraisal").count == 1
        end
      end

      describe "click on trade appraisals archived link from left nav" do
        it "should load all archived trade appraisals " do
          appraisal = create_appraisal_with_equipment_type("TA")
          appraisal.update_attribute(:archived,true)
          visit organization_appraisals_path(@organization)
          page.find("li#appraisal-link a", text: "Archived TA").click()
          page.all('table#datatable_fixed_column tbody tr').count.should == 1
        end
      end

      describe "click on used inventory link from left nav" do
        it "should load all the used inventory " do
          create_appraisal_with_equipment_type("UI")
          visit organization_appraisals_path(@organization)
          page.find("li#appraisal-link a", text: "UI - Used Inventory").click()
          page.all('table#datatable_fixed_column tbody tr').count.should == 1
        end
        it "should render appropriate create button " do
          visit organization_appraisals_path(@organization)
          page.find("li#appraisal-link a", text: "TA - Trade Appraisal").click()
          page.all("button.create_btn", text:"Create New UI - Used Inventory").count == 1
        end
      end

      describe "click on used inventory archived link from left nav" do
        it "should load all archived used inventories " do
          appraisal = create_appraisal_with_equipment_type("UI")
          appraisal.update_attribute(:archived,true)
          visit organization_appraisals_path(@organization)
          page.find("li#appraisal-link a", text: "Archived UI").click()
          page.all('table#datatable_fixed_column tbody tr').count.should == 1
        end
      end


      describe "click on new inventory link from left nav" do
        it "should load all the new inventory " do
          create_appraisal_with_equipment_type("NI")
          visit organization_appraisals_path(@organization)
          page.find("li#appraisal-link a", text: "NI - New Inventory").click()
          page.all('table#datatable_fixed_column tbody tr').count.should == 1
        end
        it "should render appropriate create button " do
          visit organization_appraisals_path(@organization)
          page.find("li#appraisal-link a", text: "TA - Trade Appraisal").click()
          page.all("button.create_btn", text:"Create New UI - Used Inventory").count == 1
        end
      end

      describe "click on new inventory archived link from left nav" do
        it "should load all archived new inventories " do
          appraisal = create_appraisal_with_equipment_type("NI")
          appraisal.update_attribute(:archived,true)
          visit organization_appraisals_path(@organization)
          page.find("li#appraisal-link a", text: "Archived NI").click()
          page.all('table#datatable_fixed_column tbody tr').count.should == 1
        end
      end

    end

    describe "with et disabled organization" do
      it "should contain all appraisals link at the left nav without any et link" do
        @organization.update_attribute(:is_equipment_type_enabled,false)
        create_appraisal_with_equipment_type
        visit organization_appraisals_path(@organization)
        expect(page.find("#appraisal-link").text.include?("All Appraisals")).to eq true
        expect(page.find("#appraisal-link").text.include?("TA - Trade Appraisal")).to eq false
        expect(page.find("#appraisal-link").text.include?("UI - Used Inventory")).to eq false
        expect(page.find("#appraisal-link").text.include?("NI - New Inventory")).to eq false
        page.all('table#datatable_fixed_column tbody tr').count.should == 2
      end
    end

  end

  def create_appraisal_with_equipment_type(et_name=nil)
    eq_type = EquipmentType.find_by(name: et_name)
    appraisal_template = FactoryGirl.create(:appraisal_template, equipment_type: eq_type)
    @organization.appraisal_templates << appraisal_template
    appraisal = FactoryGirl.create(:appraisal, appraisal_template: appraisal_template, organization: @organization)
  end


end
