FactoryGirl.define do
  factory :authorization do
    user
    provider "twitter"
    uid "13245"
    confirm_token Devise.friendly_token[0, 20]

    trait :email_confirmed do
      status true
      email_confirmed true
    end

    trait :not_email_confirmed do
      status false
      email_confirmed false
    end
  end
end
