FactoryGirl.define do
  factory :vote do
    score 0
    user

    trait :up do
      score 1
    end

    trait :down do
      score -1
    end
  end
end
