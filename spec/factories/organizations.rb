FactoryGirl.define do
  factory :organization do
    name { "#{Faker::Name.name} Organization" }
    acronym "ANA"
    association :owner, factory: :user
    association :admin, factory: :user
  end
end
