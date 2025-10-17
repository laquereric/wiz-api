# frozen_string_literal: true

require "faraday"
require "json"
require "time"

module Wiz
  # Handles OAuth2 authentication for the WIZ API
  class Auth
    attr_reader :config

    def initialize(config)
      @config = config
      @access_token = nil
      @token_expires_at = nil
    end

    # Get a valid access token, refreshing if necessary
    #
    # @return [String] the access token
    # @raise [AuthenticationError] if authentication fails
    def access_token
      return @access_token if token_valid?

      fetch_access_token
      @access_token
    end

    # Check if the current token is valid
    #
    # @return [Boolean] true if token is valid and not expired
    def token_valid?
      return false if @access_token.nil?
      return false if @token_expires_at.nil?

      Time.now < @token_expires_at - 60 # Refresh 60 seconds before expiry
    end

    # Force a token refresh
    #
    # @return [String] the new access token
    def refresh!
      @access_token = nil
      @token_expires_at = nil
      access_token
    end

    private

    # Fetch a new access token from the OAuth endpoint
    #
    # @raise [AuthenticationError] if authentication fails
    def fetch_access_token
      config.logger.debug("Fetching new access token from #{config.auth_url}")

      response = connection.post do |req|
        req.headers["Content-Type"] = "application/x-www-form-urlencoded"
        req.body = URI.encode_www_form(
          grant_type: "client_credentials",
          client_id: config.client_id,
          client_secret: config.client_secret,
          audience: "wiz-api"
        )
      end

      handle_auth_response(response)
    rescue Faraday::Error => e
      raise AuthenticationError, "Failed to authenticate: #{e.message}"
    end

    # Handle the authentication response
    #
    # @param response [Faraday::Response] the HTTP response
    # @raise [AuthenticationError] if authentication fails
    def handle_auth_response(response)
      unless response.success?
        raise AuthenticationError, "Authentication failed with status #{response.status}: #{response.body}"
      end

      data = JSON.parse(response.body)
      @access_token = data["access_token"]
      expires_in = data["expires_in"] || 3600

      @token_expires_at = Time.now + expires_in

      config.logger.debug("Access token obtained, expires at #{@token_expires_at}")
    rescue JSON::ParserError => e
      raise AuthenticationError, "Failed to parse authentication response: #{e.message}"
    end

    # Create a Faraday connection for authentication
    #
    # @return [Faraday::Connection]
    def connection
      @connection ||= Faraday.new(url: config.auth_url) do |f|
        f.request :url_encoded
        f.adapter Faraday.default_adapter
        f.options.timeout = config.timeout
      end
    end
  end
end

