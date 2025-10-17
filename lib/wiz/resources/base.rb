# frozen_string_literal: true

module Wiz
  module Resources
    # Base class for all WIZ API resource clients
    class Base
      attr_reader :http

      def initialize(http)
        @http = http
      end

      private

      # Build pagination parameters
      #
      # @param limit [Integer] maximum number of results
      # @param cursor [String] pagination cursor
      # @return [Hash] pagination parameters
      def pagination_params(limit: nil, cursor: nil)
        params = {}
        params[:first] = limit if limit
        params[:after] = cursor if cursor
        params
      end

      # Extract nodes from a paginated response
      #
      # @param data [Hash] the response data
      # @param key [String] the key containing the paginated data
      # @return [Array] the nodes
      def extract_nodes(data, key)
        return [] unless data && data[key]

        data[key]["nodes"] || []
      end

      # Extract page info from a paginated response
      #
      # @param data [Hash] the response data
      # @param key [String] the key containing the paginated data
      # @return [Hash] the page info
      def extract_page_info(data, key)
        return {} unless data && data[key]

        data[key]["pageInfo"] || {}
      end
    end
  end
end

