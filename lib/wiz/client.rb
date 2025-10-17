# frozen_string_literal: true

module Wiz
  # Main client for interacting with the WIZ API
  class Client
    attr_reader :config, :auth, :http

    # Initialize a new WIZ API client
    #
    # @param client_id [String] the service account client ID
    # @param client_secret [String] the service account client secret
    # @param api_endpoint [String] the GraphQL API endpoint URL
    # @param auth_url [String] the OAuth token endpoint URL
    # @param timeout [Integer] request timeout in seconds
    # @param logger [Logger] logger instance
    #
    # @example Initialize with parameters
    #   client = Wiz::Client.new(
    #     client_id: 'your-client-id',
    #     client_secret: 'your-client-secret',
    #     api_endpoint: 'https://api.us1.app.wiz.io/graphql'
    #   )
    #
    # @example Initialize with global configuration
    #   Wiz.configure do |config|
    #     config.client_id = ENV['WIZ_CLIENT_ID']
    #     config.client_secret = ENV['WIZ_CLIENT_SECRET']
    #     config.api_endpoint = ENV['WIZ_API_ENDPOINT']
    #   end
    #   client = Wiz::Client.new
    def initialize(client_id: nil, client_secret: nil, api_endpoint: nil, auth_url: nil, timeout: nil, logger: nil)
      @config = build_configuration(
        client_id: client_id,
        client_secret: client_secret,
        api_endpoint: api_endpoint,
        auth_url: auth_url,
        timeout: timeout,
        logger: logger
      )
      @config.validate!

      @auth = Auth.new(@config)
      @http = HTTP.new(@config, @auth)
    end

    # Access the Issues resource
    #
    # @return [Resources::Issues]
    def issues
      @issues ||= Resources::Issues.new(http)
    end

    # Access the Vulnerabilities resource
    #
    # @return [Resources::Vulnerabilities]
    def vulnerabilities
      @vulnerabilities ||= Resources::Vulnerabilities.new(http)
    end

    # Access the Assets resource
    #
    # @return [Resources::Assets]
    def assets
      @assets ||= Resources::Assets.new(http)
    end

    # Execute a custom GraphQL query
    #
    # @param query [String] the GraphQL query string
    # @param variables [Hash] the query variables
    # @return [Hash] the response data
    def query(query, variables: {})
      http.query(query, variables: variables)
    end

    # Execute a custom GraphQL mutation
    #
    # @param mutation [String] the GraphQL mutation string
    # @param variables [Hash] the mutation variables
    # @return [Hash] the response data
    def mutate(mutation, variables: {})
      http.mutate(mutation, variables: variables)
    end

    private

    # Build configuration from parameters or global config
    #
    # @return [Configuration]
    def build_configuration(client_id:, client_secret:, api_endpoint:, auth_url:, timeout:, logger:)
      config = Configuration.new

      config.client_id = client_id || Wiz.configuration.client_id
      config.client_secret = client_secret || Wiz.configuration.client_secret
      config.api_endpoint = api_endpoint || Wiz.configuration.api_endpoint
      config.auth_url = auth_url || Wiz.configuration.auth_url
      config.timeout = timeout || Wiz.configuration.timeout
      config.logger = logger || Wiz.configuration.logger

      config
    end
  end
end

