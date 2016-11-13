source 'https://rubygems.org'
ruby '2.3.1'

# Base
gem 'rails',        '~> 5.0.0', '>= 5.0.0.1'
gem 'pg',           '~> 0.18'
gem 'puma',         '~> 3.0'

# Git sources
gem 'activeadmin',         git: 'https://github.com/activeadmin/activeadmin.git'
gem 'inherited_resources', git: 'https://github.com/activeadmin/inherited_resources.git' # Used by activeadmin

# Gems!
gem 'figaro',       '~> 1.1.1'
gem 'jbuilder',     '~> 2.5'
gem 'oj',           '~> 2.12.14' # Used by rollbar
gem 'rollbar',      '~> 2.13.3'
gem 'redis'
gem 'haikunator'

# Assets
gem 'sass-rails',   '~> 5.0'
gem 'uglifier',     '>= 1.3.0'
gem 'jquery-rails'
gem 'turbolinks',   '~> 5'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'coffee-rails', '~> 4.2' # Teaspoon still needs coffee-rails, unfortunately (https://github.com/jejacks0n/teaspoon/issues/405)
  gem 'rspec-rails', '~> 3.5'
  gem "teaspoon-jasmine"
  gem "selenium-webdriver"
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
