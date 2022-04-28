source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.0'

gem 'rails', '~> 6.1.4', '>= 6.1.5.1'
gem 'mysql2', '>= 0.4.4', '< 0.6.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'lograge'
gem 'rack-cors', '~> 1.1.0'
gem 'rack', '>= 2.2.3'
gem "websocket-extensions", ">= 0.1.5"

gem 'devise'
gem 'omniauth-discord'
gem 'omniauth-rails_csrf_protection', '~> 1.0'

gem 'bootstrap', '~> 4.3.1'
gem 'jquery-rails'
gem 'font-awesome-rails'
gem 'ransack'
gem 'chunky_png'
gem 'redis-namespace'
gem 'will_paginate'
gem 'will_paginate-bootstrap4'
gem 'traco'
gem 'rest-client'
gem 'whenever'
gem 'sortable-rails'
gem 'momentjs-rails'
gem 'rails_bootstrap_sortable'

# Discord interactions
gem 'ed25519'
gem 'discordrb-webhooks', '3.3.0'

# Compatibility fix for Rails 6 / Ruby 3.1. Should be resolved in Rails 7.0.1
gem 'net-imap', require: false
gem 'net-pop', require: false
gem 'net-smtp', require: false

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rack-mini-profiler'
end

group :development do
  gem 'web-console'
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'puma', '~> 5.0'
  gem 'annotate'

  gem 'capistrano', '3.16.0'
  gem 'capistrano-bundler'
  gem 'capistrano-rbenv'
  gem 'capistrano-rails'
end
