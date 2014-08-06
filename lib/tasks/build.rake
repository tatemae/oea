require 'rubygems'
require 'bundler'

desc 'Build the Ember app'
task :build do |t|
  `cd "./frontend" && ember build`
  `cp ./frontend/dist/assets/vendor.js ./app/assets/javascripts/oea/`
  `cp ./frontend/dist/assets/oea.js ./app/assets/javascripts/oea/`
end

