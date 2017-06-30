# frozen_string_literal: true
# A sample Gemfile
source "https://rubygems.org"
ruby '2.4.1'

gem 'sinatra', require: 'sinatra/base'
gem 'rake'
gem 'thin'
gem 'sequel'
gem 'sinatra-sequel'
gem 'bcrypt'
gem 'hal_decorator'
gem 'redcarpet'

group :production, :development do
  gem 'pg'
end

group :development, :test do
  gem 'pry'
  gem 'pry-byebug'
end

group :test do
  gem 'sqlite3'
  gem 'minitest'
  gem 'rack-test'
end

