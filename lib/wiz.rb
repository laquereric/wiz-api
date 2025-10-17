# frozen_string_literal: true

require_relative "wiz/version"
require_relative "wiz/errors"
require_relative "wiz/configuration"
require_relative "wiz/auth"
require_relative "wiz/http"
require_relative "wiz/client"
require_relative "wiz/models/base"
require_relative "wiz/models/issue"
require_relative "wiz/models/vulnerability"
require_relative "wiz/models/asset"
require_relative "wiz/resources/base"
require_relative "wiz/resources/issues"
require_relative "wiz/resources/vulnerabilities"
require_relative "wiz/resources/assets"

# Main module for the WIZ API client
module Wiz
  class << self
    # Configure the WIZ client globally
    #
    # @yield [Configuration] the configuration object
    # @return [Configuration] the configuration object
    #
    # @example
    #   Wiz.configure do |config|
    #     config.client_id = ENV['WIZ_CLIENT_ID']
    #     config.client_secret = ENV['WIZ_CLIENT_SECRET']
    #     config.api_endpoint = ENV['WIZ_API_ENDPOINT']
    #   end
    def configure
      yield(configuration)
      configuration
    end

    # Get the global configuration
    #
    # @return [Configuration] the configuration object
    def configuration
      @configuration ||= Configuration.new
    end

    # Reset the global configuration
    #
    # @return [Configuration] a new configuration object
    def reset_configuration!
      @configuration = Configuration.new
    end
  end
end

