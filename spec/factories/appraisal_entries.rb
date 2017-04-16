# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :appraisal_entry do
    value "MyText"
    appraisal nil
    template_field nil
  end
end
