ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'email_spec'
require 'rspec/autorun'
require 'database_cleaner'
require 'pry'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'
require 'shoulda/matchers'
require 'pundit/rspec'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!
Capybara.javascript_driver = :webkit
include Warden::Test::Helpers

RSpec.configure do |config|
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)

  config.include RocketPants::TestHelper, type: :controller
  config.include RocketPants::RSpecMatchers, type: :controller

  config.include FactoryGirl::Syntax::Methods

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!
  config.order = "random"

  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation, {:except => %w[equipment_types email_templates]}
    Warden.test_mode!
  end

  config.before(:each) { DatabaseCleaner.strategy = :transaction }
  config.before(:each, js: true) { DatabaseCleaner.strategy = :truncation, {:except => %w[equipment_types email_templates]} }
  config.before(:each) { DatabaseCleaner.start }

  config.after(:each) do
    DatabaseCleaner.clean
    reset_mailer
    Warden.test_reset!
  end

  config.before(:each, type: :controller) do
    current_user = double(:global_current_user)
    controller.stub(current_user: current_user)
  end

  Capybara.javascript_driver = :selenium

  Capybara.register_driver :selenium_firefox_driver do |app|
    profile = Selenium::WebDriver::Firefox::Profile.new
    Capybara::Selenium::Driver.new(app, :browser => :firefox, :profile => profile)
  end
  config.before(:all) do
    Rails.application.load_seed # loading seeds
  end

end
