# frozen_string_literal: true

require "faraday"
require "faraday/retry"
require "json"

module Wiz
  # HTTP client for making GraphQL requests to the WIZ API
  class HTTP
    attr_reader :config, :auth

    def initialize(config, auth)
      @config = config
      @auth = auth
    end

    # Execute a GraphQL query
    #
    # @param query [String] the GraphQL query string
    # @param variables [Hash] the query variables
    # @return [Hash] the response data
    # @raise [GraphQLError] if the GraphQL query returns errors
    # @raise [APIError] if the HTTP request fails
    def query(query, variables: {})
      config.logger.debug("Executing GraphQL query: #{query[0..100]}...")

      response = connection.post do |req|
        req.headers["Authorization"] = "Bearer #{auth.access_token}"
        req.headers["Content-Type"] = "application/json"
        req.body = JSON.generate(
          query: query,
          variables: variables
        )
      end

      handle_response(response)
    end

    # Execute a GraphQL mutation
    #
    # @param mutation [String] the GraphQL mutation string
    # @param variables [Hash] the mutation variables
    # @return [Hash] the response data
    # @raise [GraphQLError] if the GraphQL mutation returns errors
    # @raise [APIError] if the HTTP request fails
    def mutate(mutation, variables: {})
      query(mutation, variables: variables)
    end

    private

    # Handle the HTTP response
    #
    # @param response [Faraday::Response] the HTTP response
    # @return [Hash] the response data
    # @raise [GraphQLError] if the GraphQL query returns errors
    # @raise [APIError] if the HTTP request fails
    def handle_response(response)
      unless response.success?
        handle_error_response(response)
      end

      data = JSON.parse(response.body)

      if data["errors"]
        raise GraphQLError.new(
          "GraphQL query returned errors: #{data['errors'].map { |e| e['message'] }.join(', ')}",
          errors: data["errors"]
        )
      end

      data["data"]
    rescue JSON::ParserError => e
      raise APIError.new(
        "Failed to parse API response: #{e.message}",
        status_code: response.status,
        response_body: response.body
      )
    end

    # Handle error responses
    #
    # @param response [Faraday::Response] the HTTP response
    # @raise [APIError] with appropriate error class
    def handle_error_response(response)
      error_class = case response.status
                    when 401, 403
                      AuthenticationError
                    when 404
                      NotFoundError
                    when 429
                      RateLimitError
                    when 500..599
                      ServerError
                    else
                      APIError
                    end

      raise error_class.new(
        "API request failed with status #{response.status}",
        status_code: response.status,
        response_body: response.body
      )
    end

    # Create a Faraday connection for API requests
    #
    # @return [Faraday::Connection]
    def connection
      @connection ||= Faraday.new(url: config.api_endpoint) do |f|
        f.request :json
        f.request :retry, {
          max: 3,
          interval: 0.5,
          interval_randomness: 0.5,
          backoff_factor: 2,
          retry_statuses: [429, 500, 502, 503, 504],
          methods: [:get, :post]
        }
        f.response :logger, config.logger, { headers: false, bodies: false } do |logger|
          logger.filter(/(Authorization:)(.*)/, '\1 [REDACTED]')
        end
        f.adapter Faraday.default_adapter
        f.options.timeout = config.timeout
      end
    end
  end
end

