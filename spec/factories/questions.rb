FactoryGirl.define do
  factory :question do
    title "Rspec Title"
    body "Rspec Body"
  end

  factory :invalid_question, class:"Question" do
    title nil
    body nil
  end
end
