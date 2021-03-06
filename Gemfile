source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0', '>= 6.0.3.4'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.2.3'

# Use Puma as the app server
gem 'puma'

# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'

# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
gem 'image_processing', '~> 1.10.3'
gem 'mini_magick', '~> 4.10.1'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
#gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'devise'
gem "audited", "~> 4.9"
gem 'friendly_id', '~> 5.2.4'
gem 'will_paginate', '~> 3.1.0'

#BULMA
gem 'bulma-rails', '~> 0.9.0'
gem 'bulma-extensions-rails', '~> 6.2.7'
gem 'bulma_form_builder'


# PDF
# gem 'wicked_pdf'
# gem 'wkhtmltopdf-binary'

# XLSX sheet
gem 'spreadsheet'
gem 'yaml_db'

# lol_dba is a small package of rake tasks that scan your application models 
# and displays a list of columns that probably should be indexed. Also, it can generate .sql migration scripts.
# https://github.com/plentz/lol_dba
gem 'lol_dba'

gem 'capture_stdout', '~> 0.0.1'

# Ruby finite-state-machine-inspired API for modeling workflow 
gem 'workflow'
gem 'workflow-activerecord'

# ActiveStorage Service to store files PostgeSQL.
gem 'active_storage-postgresql'

# cloud file storage service Amazon’s S3.
#gem "aws-sdk-s3", require: false

# A simple, efficient worker queue for Ruby & PostgreSQL
# gem 'queue_classic', :git => 'https://github.com/QueueClassic/queue_classic.git'

# Sucker Punch is a single-process Ruby asynchronous processing library.
gem 'sucker_punch', '~> 2.0'

# gem 'exception_notification'
