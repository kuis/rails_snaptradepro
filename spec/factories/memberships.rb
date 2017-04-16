FactoryGirl.define do
  factory :membership do
    role
    organization

    trait :invitation_sent do
      invitation_token { SecureRandom.hex }
      invitation_created_at { Time.now - 1.hour }
      invitation_sent_at { Time.now - 1.hour }
    end

    trait :invitation_pending do
      invitation_token { SecureRandom.hex }
      invitation_created_at { Time.now - 1.hour }
      invitation_sent_at nil
    end

    trait :invitation_accepted do
      invitation_token nil
      invitation_created_at { Time.now - 1.hour }
      invitation_sent_at { Time.now - 1.hour }
      invitation_accepted_at { Time.now }
    end

    trait :invitation_revoked do
      invitation_token nil
      invitation_created_at { Time.now - 31.days }
      invitation_sent_at nil
      invitation_accepted_at nil
    end
  end
end
