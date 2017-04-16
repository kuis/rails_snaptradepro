FactoryGirl.define do
  factory :customer do
    sequence(:account_name) { |n| "Westman Bulk#{n}" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    business_phone "7234123111"
    organization
  end
end
