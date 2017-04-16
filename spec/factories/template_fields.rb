FactoryGirl.define do
  factory :template_field do
    weight 50

    factory :id_field do
      sequence(:name) { |n| "id_number#{n}" }
      label "ID Number"
      field_type "Text Field"
    end

    factory :mileage_field do
      sequence(:name) { |n| "mileage#{n}" }
      label "Mileage"
      field_type "Numeric"
      formatting "comma-separated: true"
    end

    factory :engine_condition_field do
      sequence(:name) { |n| "engine_condition#{n}" }
      label "Engine Condition"
      field_type "Text Area"
    end

    factory :engine_size do
      sequence(:name) { |n| "engine_size#{n}" }
      label "Engine Size"
      field_type "Select"
      choices "V6\r\nV8"
    end

    factory :sale_type_field do
      sequence(:name) { |n| "sale_type#{n}" }
      label "Sale Type"
      field_type "Select"
      choices "Owner\r\nDealer\r\nBank"
    end

    factory :required_text_field do
      sequence(:name) { |n| "required_text_field#{n}" }
      label "Required Text Field"
      field_type "Text Field"
      required true
    end
    factory :serial_no_field do
      name "serial_no"
      label "Vin#"
      field_type "Text Area"
    end
    factory :last6_field do
      name "last6"
      label "Last6"
      field_type "Text Field"
    end
    factory :last8_field do
      name "last8"
      label "Last8"
      field_type "Text Field"
    end
  end
end
