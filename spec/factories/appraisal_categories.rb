FactoryGirl.define do
  factory :appraisal_category do
    factory :id_category do
      sequence(:name) { |n| "unit_identification#{n}" }
      label "Unit Identification"

      after(:create) do |c|
        c.template_fields << create(:id_field)
        c.template_fields << create(:sale_type_field)
      end
    end

    factory :powertrain_category do
      sequence(:name) { |n| "powertrain#{n}" }
      label "Powertrain"

      after(:create) do |c|
        c.template_fields << create(:engine_condition_field)
        c.template_fields << create(:mileage_field)
        c.template_fields << create(:engine_size)
      end
    end

    factory :required_fields_category do
      sequence(:name) { |n| "required_fields#{n}" }
      label "Required Fields"

      after(:create) do |c|
        c.template_fields << create(:required_text_field)
      end
    end
  end
end
