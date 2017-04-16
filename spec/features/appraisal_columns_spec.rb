require "spec_helper"

describe "Appraisal columns" do
  let!(:user) { create(:user, :logged_in, admin: true) }
 it "should have field and render it on column1 as selected by STP admin" do

   @organization = FactoryGirl.create(:organization)

   @column1 = FactoryGirl.create(:appraisal_column, column_name: "column1", organization: @organization)

   @appraisal_category = FactoryGirl.create(:powertrain_category)
   @appraisal_template = FactoryGirl.create(:appraisal_template)

   @column1.template_fields << @appraisal_category.template_fields

   @appraisal = FactoryGirl.create(:appraisal, organization: @organization)
   @appraisal.set_field_value(2,'5000')
   @appraisal.save

   visit organization_appraisals_path(@organization)
   page.find("select option",text: 'Mileage').click

   page.all("th", text: "Mileage").count == 1
   page.all("td", text: "5000").count == 1

   visit organization_appraisals_path(@organization)
   page.all("th", text: "Mileage").count == 1
   page.all("td", text: "5000").count == 1

 end
end
