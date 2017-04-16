FactoryGirl.define do
  factory :appraisal_template do
    sequence(:name) { |n| "heavy_trick#{n}" }
    label "Heavy Truck"

    after(:create) do |at|
      at.appraisal_categories << create(:powertrain_category)
      at.appraisal_categories << create(:id_category)
    end
  end
end
