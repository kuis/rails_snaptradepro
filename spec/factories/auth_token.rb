FactoryGirl.define do
  factory :auth_token do
    user
    token { SecureRandom.hex }
  end
end
