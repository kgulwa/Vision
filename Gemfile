source "https://rubygems.org"

gem "rails", "~> 8.1.2"
gem "propshaft", "~> 1.3"  
gem "puma", ">= 5.0"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "jsbundling-rails"
gem "bcrypt", "~> 3.1.7"
gem "tzinfo-data", platforms: %i[windows jruby]
gem "pg"                      # PostgreSQL
gem "bootsnap", require: false
gem "image_processing", "~> 1.2"
gem "groupdate"
group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "bundler-audit", require: false
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "tailwindcss-rails"
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
end

group :development do
  gem "web-console"
end

group :test do
  gem "simplecov", require: false
  gem "capybara"
  gem "selenium-webdriver"
  gem "shoulda-matchers"
end
