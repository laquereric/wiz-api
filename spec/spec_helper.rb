# frozen_string_literal: true

require "rspec/core"
require "wiz"
require "webmock/rspec"
require "vcr"
require "simplecov"

SimpleCov.start do
  add_filter "/spec/"
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.filter_sensitive_data("<CLIENT_ID>") { ENV["WIZ_CLIENT_ID"] }
  config.filter_sensitive_data("<CLIENT_SECRET>") { ENV["WIZ_CLIENT_SECRET"] }
  config.filter_sensitive_data("<ACCESS_TOKEN>") do |interaction|
    if interaction.response.body.include?("access_token")
      JSON.parse(interaction.response.body)["access_token"]
    end
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    Wiz.reset_configuration!
  end
end

