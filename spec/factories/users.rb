FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password "please123"

    trait :logged_in do
      after(:create) { |u| login_as(u, scope: :user) }
    end

    factory :org_member do
      after(:create) do |user|
        FactoryGirl.create(:membership, user: user, 
                                        organization: user.current_organization, 
                                        role: FactoryGirl.create(:role))
      end

      factory :org_admin do
        after(:create) do |user|
          user.current_organization.admin = user
          user.save
        end
      end

      factory :org_owner do
        after(:create) do |user|
          user.current_organization.owner = user
          user.save
        end
      end
    end
  end
end
