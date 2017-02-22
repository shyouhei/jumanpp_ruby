ENV['RACK_ENV'] = 'test'
require 'bundler/setup'
require 'rspec'
require 'rspec/its'
require 'simplecov'

RSpec.configure do |c|
  c.filter_run_excluding skip: true
end

SimpleCov.start do
  add_filter 'vendor/'
  add_filter 'spec/'
end

require_relative '../lib/jumanpp' # <- need this *after* simplecov
