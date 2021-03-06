source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use MySQL as the production database for Active Record
gem 'mysql2', group: :production

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
# gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the production app server
gem 'unicorn', group: :production

# Use Capistrano for deployment
gem 'capistrano', '~> 2.15.5', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

group :development, :test do
  gem "sqlite3"
  gem "thin"
  gem "rspec-rails"
  gem "webrat"
  gem "simplecov", require: false
  gem "rails_best_practices", require: false
  gem "spring", "~> 0.0.11", require: false
  gem "guard", "~> 1.8.3", require: false
  gem "guard-livereload", "~> 1.4.0", require: false
  gem "guard-rspec", require: false
  gem "guard-spring", require: false
  gem "capistrano-unicorn", require: false
end
group :test do
  gem "factory_girl_rails"
  gem "shoulda-matchers"
end
group :assets do
  gem "turbo-sprockets-rails3"
end

gem 'uuidtools'
gem 'nokogiri', '~> 1.6.0'
