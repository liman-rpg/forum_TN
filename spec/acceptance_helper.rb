require "rails_helper"

RSpec.configure do |config|
  Capybara.javascript_driver = :webkit

  Capybara.server = :puma

  config.include AcceptenceMacros, type: :feature

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.after(:suite) do
    FileUtils.rm_rf(Dir["#{Rails.root}/public/uploads/attachment"])
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
