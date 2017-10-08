FactoryGirl.define do
  sequence(:email) { |n| "rspec#{n}@test.com" }

  factory :user do
    name 'Rspec Username'
    email
    password 'welcome'
  end
end
