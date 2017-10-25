FactoryGirl.define do
  sequence(:title) { |n| "RspecQuestionTitle#{n}" }

  factory :question do
    title
    body "RspecQuestionBody"
    user

    trait :with_attachment do
      after(:build) { |question| create(:attachment, attachable: question) }
    end
  end

  factory :invalid_question, class:"Question" do
    title nil
    body nil
  end
end
