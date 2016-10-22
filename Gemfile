source 'https://rubygems.org'
ruby '2.3.1'

gem 'rails',        '~> 5.0.0', '>= 5.0.0.1'
gem 'pg',           '~> 0.18'
gem 'puma',         '~> 3.0'

gem 'figaro',       '~> 1.1.1'
gem 'jbuilder',     '~> 2.5'
gem 'oj',           '~> 2.12.14' # Used by rollbar
gem 'rollbar',      '~> 2.13.3'

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
end

group :development do
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec'
end
