FactoryGirl.define do
  factory :answer do
    body "Rspec Body Answer"
    question
    user

    trait :with_attachment do
      after(:build) { |answer| create(:attachment, attachable: answer) }
    end
  end

  factory :invalid_answer, class:"Answer" do
    body nil
  end
end
