# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

group :development, :test do
  gem 'faker', git: 'https://github.com/stympy/faker.git', branch: 'master'

  gem 'fasterer'

  gem 'rubocop'

  gem 'pry'

  gem 'rspec'

  gem 'simplecov', require: false, group: :test

  gem 'rspec_junit_formatter', group: :test
end

gem 'i18n'
