source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.7'
gem 'rails', '5.2.3'
gem 'carrierwave',             '1.2.2'
gem "mini_magick",             '>= 4.9.4'
gem 'active_storage_validations', '0.8.2'
gem 'dotenv-rails'
gem 'fog-aws'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'bootstrap', '~> 4.1.1'
gem 'jquery-rails'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'devise'
gem 'faker'
gem 'kaminari'

group :production do
 gem 'fog', '1.42'
end

group :development, :test do
  gem 'rspec-rails', '~> 4.0.0.beta2'
  gem 'rails-controller-testing'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rubocop-airbnb'
  gem "factory_bot_rails", "~> 4.10.0"
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
  gem 'webdrivers'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
