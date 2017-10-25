FactoryGirl.define do
  factory :attachment do
    file { File.open("#{Rails.root}/spec/acceptance_helper.rb") }
  end
end
