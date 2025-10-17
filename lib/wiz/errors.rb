# frozen_string_literal: true

module Wiz
  # Base error class for all WIZ API errors
  class Error < StandardError; end

  # Raised when authentication fails
  class AuthenticationError < Error; end

  # Raised when an API request fails
  class APIError < Error
    attr_reader :status_code, :response_body

    def initialize(message, status_code: nil, response_body: nil)
      super(message)
      @status_code = status_code
      @response_body = response_body
    end
  end

  # Raised when a GraphQL error occurs
  class GraphQLError < Error
    attr_reader :errors

    def initialize(message, errors: [])
      super(message)
      @errors = errors
    end
  end

  # Raised when configuration is invalid
  class ConfigurationError < Error; end

  # Raised when a required parameter is missing
  class MissingParameterError < Error; end

  # Raised when a resource is not found
  class NotFoundError < APIError; end

  # Raised when rate limit is exceeded
  class RateLimitError < APIError; end

  # Raised when the server returns an error
  class ServerError < APIError; end
end

