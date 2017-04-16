# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :appraisal_column do
    column_name "column1"
    static_fields %w(number unit name)
  end
end
