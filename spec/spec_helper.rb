# frozen_string_literal: true

require 'bundler/setup'
require 'json/jwt'
require 'okta_jwt_validation'
require 'pry'
require 'simplecov'
require 'webmock/rspec'

SimpleCov.start

$LOAD_PATH << File.expand_path('/spec/support/fixtures/*.json')

module Rails
  def self.root
    Pathname.new(File.expand_path(__dir__))
  end

  def self.cache
    @cache ||= ActiveSupport::Cache::MemoryStore.new
  end

  def self.env
    'test'
  end
end

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
