# frozen_string_literal: true

require "logger"

module Wiz
  # Configuration class for the WIZ API client
  class Configuration
    attr_accessor :client_id, :client_secret, :api_endpoint, :auth_url, :timeout, :logger

    # Default authentication URL
    DEFAULT_AUTH_URL = "https://auth.app.wiz.io/oauth/token"

    # Default timeout in seconds
    DEFAULT_TIMEOUT = 30

    def initialize
      @client_id = nil
      @client_secret = nil
      @api_endpoint = nil
      @auth_url = DEFAULT_AUTH_URL
      @timeout = DEFAULT_TIMEOUT
      @logger = Logger.new($stdout, level: Logger::WARN)
    end

    # Validate that all required configuration is present
    #
    # @raise [ConfigurationError] if required configuration is missing
    def validate!
      raise ConfigurationError, "client_id is required" if client_id.nil? || client_id.empty?
      raise ConfigurationError, "client_secret is required" if client_secret.nil? || client_secret.empty?
      raise ConfigurationError, "api_endpoint is required" if api_endpoint.nil? || api_endpoint.empty?
      raise ConfigurationError, "auth_url is required" if auth_url.nil? || auth_url.empty?
    end

    # Check if configuration is valid
    #
    # @return [Boolean] true if configuration is valid
    def valid?
      validate!
      true
    rescue ConfigurationError
      false
    end
  end
end

