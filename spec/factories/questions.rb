FactoryGirl.define do
  sequence(:title) { |n| "RspecQuestionTitle#{n}" }

  factory :question do
    title
    body "Rspec Body"
  end

  factory :invalid_question, class:"Question" do
    title nil
    body nil
  end
end
