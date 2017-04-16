# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :role do
    name "Rep"

    factory :member_role do
      profile "Member"
    end
  end
end
