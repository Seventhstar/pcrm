source 'https://rubygems.org'

ruby '2.6.6'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.2', '>= 5.2.3'
#gem 'rails', '~> 6.0.3', '>= 6.0.3.2'

gem 'pg'
gem 'puma', '~> 4.1'

group :development, :test do
  gem 'bootsnap'
  gem 'coffee-script-source', '1.12.2'
  gem "better_errors"
  gem 'rspec-rails'
  gem "capybara"
end
      
group :production do
  gem 'rails_12factor'
end

# Use SCSS for stylesheets
gem 'sass-rails', '>= 5'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', github: 'rails/coffee-rails'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'bcrypt', git: 'https://github.com/codahale/bcrypt-ruby.git', require: 'bcrypt'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '>= 3.3.0'
  gem "binding_of_caller"
end

group :test do
  gem 'launchy'
  gem 'factory_bot_rails'
  gem 'database_cleaner'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers'#, git: 'https://github.com/thoughtbot/shoulda-matchers.git', branch: 'rails-5'  
  gem 'selenium-webdriver'
  gem 'json_spec'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'simple_form'
gem 'simple-navigation', '4.0.3'
gem 'bootstrap-datepicker-rails'
gem 'jquery-ui-rails'
gem 'yaml_db', git: 'https://github.com/Seventhstar/yaml_db2.git'
# gem 'font-kit-rails'
gem 'will_paginate'
gem 'bootstrap_tokenfield_rails'

#gem 'paper_trail','8.1.2'
gem 'paper_trail'

gem 'jquery.fileupload-rails'
gem 'nokogiri'
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

gem 'remotipart'
gem 'gon'
gem 'slim'
gem 'plyr-rails'
gem 'vuejs-rails'
gem 'cocoon'
gem 'json'
#gem 'pdfjs_viewer-rails', git: 'https://github.com/Seventhstar/pdfjs_viewer-rails2.git'
gem 'pdfjs_viewer-rails'
gem 'database_validations'
gem 'sidekiq'

gem "aws-sdk-s3", require: false
