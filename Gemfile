source 'https://rubygems.org'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# gem 'rails', '4.2.0'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.3'

gem 'pg'

# Use Puma as the app server
gem 'puma', '~> 3.7'

group :development, :test do
#  gem 'coffee-script-source', '1.8.0'
  gem 'rspec-rails'
  gem "better_errors"
  gem "capybara"
end
          
group :production do

# Use Unicorn as the app server
#  gem 'unicorn'
  gem 'rails_12factor', '0.0.2'
end

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .coffee assets and views
# gem 'coffee-rails', '~> 4.1.0'
gem 'coffee-rails', '~> 4.2'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  # gem 'web-console', '~> 2.0'
  gem "binding_of_caller"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'simple_form'
gem 'simple-navigation', '4.0.3'
gem 'bootstrap-datepicker-rails'
gem 'jquery-ui-rails'
gem 'bcrypt'
gem 'yaml_db'
gem 'font-kit-rails'
gem 'will_paginate'
gem 'bootstrap_tokenfield_rails'
gem 'paper_trail'
gem 'jquery.fileupload-rails'
gem 'nokogiri', '1.6.8'
gem 'responders'
gem 'carrierwave'
gem 'mini_magick'
gem 'nprogress-rails'
gem 'RedCloth'
gem 'momentjs-rails'
gem 'tinymce-rails'
gem 'telegram-bot'

gem 'prawn'
gem 'prawn-table'

gem 'mustache-js-rails'
# gem 'mustache'
# gem 'stache'
gem 'remotipart'
gem 'gon'
gem 'slim'
gem 'pundit'