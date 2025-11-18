# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'

# Require support files
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Ensure the test database schema is up to date
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # Only enable ActiveRecord support if using ActiveRecord
  config.use_active_record = true

  # Include fixture support if needed
  config.include ActiveRecord::TestFixtures

  # Use transactional fixtures (recommended for most tests)
  config.use_transactional_fixtures = true

  # Automatically infer spec type from file location (e.g., model, controller, request)
  config.infer_spec_type_from_file_location!

  # Filter out Rails gems from backtraces
  config.filter_rails_from_backtrace!

  # Include FactoryBot methods for convenience
  config.include FactoryBot::Syntax::Methods

  # Include Devise test helpers if using Devise (optional)
  # config.include Devise::Test::IntegrationHelpers, type: :request
end

# Configure Shoulda Matchers for RSpec + Rails
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
