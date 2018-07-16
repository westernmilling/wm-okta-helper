# frozen_string_literal: true

require 'bundler/setup'
require 'json/jwt'
require 'okta_jwt_validation'
require 'pry'
require 'simplecov'

SimpleCov.start

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
end
