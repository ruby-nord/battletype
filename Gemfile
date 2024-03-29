source 'https://rubygems.org'
ruby '2.6.5'

# Base
gem 'rails',        '~> 5.1.6'
gem 'pg',           '~> 0.18'
gem 'puma',         '~> 4.3'

# Git sources
gem 'activeadmin',         git: 'https://github.com/activeadmin/activeadmin.git'
gem 'inherited_resources', git: 'https://github.com/activeadmin/inherited_resources.git' # Used by activeadmin

# Gems!
gem 'figaro',       '~> 1.1.1'
gem 'jbuilder',     '~> 2.5'
gem 'oj',           '~> 2.18.5' # Used by rollbar
gem 'rollbar',      '~> 2.13.3'
gem 'redis'
gem 'haikunator'

# Assets
gem 'sass-rails',   '~> 5.0'
gem 'uglifier',     '>= 1.3.0'
gem 'jquery-rails'
gem 'turbolinks',   '~> 5'

group :development, :test do
  gem 'pry-byebug'
  gem 'pry-rails'

  gem 'byebug', platform: :mri
  gem 'capybara',     '~> 2.7.1'
  gem 'coffee-rails', '~> 4.2' # Teaspoon still needs coffee-rails, unfortunately (https://github.com/jejacks0n/teaspoon/issues/405)
  gem 'rspec-rails', '~> 3.5'
  gem "teaspoon-jasmine"
  gem 'shoulda-matchers', '~> 3.1'
end

group :test do
  gem 'fakeredis',  "~> 0.6.0"
end

group :development do
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec'
end
