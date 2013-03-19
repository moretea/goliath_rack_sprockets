require 'bundler'
require "goliath"

Bundler.setup
Bundler.require

require 'goliath/test_helper'
require 'simplecov'
SimpleCov.start

Goliath.env = :test
Goliath::Application.run_app_on_exit = false

RSpec.configure do |c|
  c.include Goliath::TestHelper, :example_group => {
    :file_path => /spec\/integration/
  }
end
