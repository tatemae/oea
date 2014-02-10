# clean up:
# rm -rf ~/.bundle/ ~/.gem/; rm -rf $GEM_HOME/bundler/ $GEM_HOME/cache/bundler/; rm -rf .bundle/; rm -rf vendor/cache/; rm -rf Gemfile.lock
# rvm gemset empty oea

source 'https://rubygems.org'
ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

# Use postgresql as the database for Active Record
gem 'pg'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.0.1'

# User Auth
gem 'devise', '>=3.0.0'

# html/xml parsers
gem 'nokogiri'

gem 'nokogiri-happymapper', :require => 'happymapper'

gem 'will_paginate', '~> 3.0.3'

gem 'figaro'

gem 'ruby-saml-mod'

# Ember stuff
gem 'ember-rails'
gem 'ember-source', '~> 1.3.0' # or the version you need

# Server
gem 'unicorn'

# Charts
gem "chartkick"
gem 'groupdate' # for grouping the chart data by date

gem 'newrelic_rpm'

# UI
gem 'sass-rails', '~> 4.0.0'
gem 'bootstrap-sass', '~> 3.0.3.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# core extensions
gem 'addressable', '~> 2.3.5' #URI implementation

group :development, :test do
  gem 'rspec-rails', '~> 2.0'
  gem 'debugger'
  gem 'email_spec', '~> 1.2.1'
end

group :test do
  #gem 'suit', '~> 0.1.5'
  gem 'factory_girl_rails'
  #gem 'shoulda-matchers', '~> 1.1.0'
end
