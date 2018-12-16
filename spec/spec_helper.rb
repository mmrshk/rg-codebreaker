# frozen_string_literal: true

require 'rspec'
require 'yaml'
require 'simplecov'
require_relative '../autoload.rb'

SimpleCov.start do
  minimum_coverage 95
end

require 'bundler/setup'
require 'codebreaker'
