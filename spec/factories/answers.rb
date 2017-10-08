FactoryGirl.define do
  factory :answer do
    body "Rspec Body Answer"
    question
    user
  end

  factory :invalid_answer, class:"Answer" do
    body nil
  end
end
