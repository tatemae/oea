# clean up:
# rm -rf ~/.bundle/ ~/.gem/; rm -rf $GEM_HOME/bundler/ $GEM_HOME/cache/bundler/; rm -rf .bundle/; rm -rf vendor/cache/; rm -rf Gemfile.lock
# rvm gemset empty oea

source 'https://rubygems.org'
ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use postgresql as the database for Active Record
gem 'pg'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.0.1'

# User Auth
gem 'devise', '3.0.0.rc'

# html/xml parsers
gem 'nokogiri'

gem 'nokogiri-happymapper', :require => 'happymapper'

gem 'will_paginate', '~> 3.0.3'

gem 'figaro'

# Ember stuff
gem 'ember-rails'
gem 'ember-source', '1.0.0.rc6.2'

# Charts
gem "chartkick"
gem 'groupdate' # for grouping the chart data by date

# Gems used only for assets and not required
# in production environments by default.
#group :assets do
  # Use SCSS for stylesheets
  gem 'sass-rails', '~> 4.0.0.rc1'
  gem 'coffee-rails', '~> 4.0.0'
  # Use Uglifier as compressor for JavaScript assets
  gem 'uglifier', '>= 1.3.0'
  gem 'bootstrap-sass-rails', '>= 2.3.1.2'
  gem 'font-awesome-sass-rails'
  gem 'flatui-rails'
#end

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
