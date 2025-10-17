# frozen_string_literal: true

module Wiz
  module Resources
    # Client for interacting with WIZ Cloud Assets
    class Assets < Base
      # List assets with optional filters
      #
      # @param cloud_provider [String, Array<String>] filter by cloud provider (AWS, AZURE, GCP)
      # @param type [String, Array<String>] filter by asset type
      # @param limit [Integer] maximum number of results (default: 50)
      # @param cursor [String] pagination cursor
      # @return [Array<Models::Asset>] array of assets
      #
      # @example
      #   assets = client.assets.list(cloud_provider: 'AWS', limit: 100)
      def list(cloud_provider: nil, type: nil, limit: 50, cursor: nil)
        variables = pagination_params(limit: limit, cursor: cursor)
        variables[:filterBy] = build_filter(cloud_provider: cloud_provider, type: type)

        data = http.query(LIST_QUERY, variables: variables)
        nodes = extract_nodes(data, "graphSearch")

        nodes.map { |node| Models::Asset.new(node) }
      end

      # Get a specific asset by ID
      #
      # @param id [String] the asset ID
      # @return [Models::Asset] the asset
      # @raise [NotFoundError] if the asset is not found
      #
      # @example
      #   asset = client.assets.get('asset-id')
      def get(id)
        raise MissingParameterError, "id is required" if id.nil? || id.empty?

        variables = { id: id }
        data = http.query(GET_QUERY, variables: variables)

        raise NotFoundError, "Asset not found: #{id}" unless data && data["graphEntity"]

        Models::Asset.new(data["graphEntity"])
      end

      private

      # Build filter parameters
      #
      # @param cloud_provider [String, Array<String>] cloud provider filter
      # @param type [String, Array<String>] asset type filter
      # @return [Hash] filter parameters
      def build_filter(cloud_provider: nil, type: nil)
        filter = {}

        if cloud_provider
          filter[:cloudProvider] = Array(cloud_provider)
        end

        if type
          filter[:type] = Array(type)
        end

        filter.empty? ? nil : filter
      end

      # GraphQL query for listing assets
      LIST_QUERY = <<~GRAPHQL
        query ListAssets($first: Int, $after: String, $filterBy: GraphEntityFilters) {
          graphSearch(first: $first, after: $after, filterBy: $filterBy) {
            nodes {
              id
              name
              type
              cloudProvider
              region
              status
              createdAt
              tags {
                key
                value
              }
              ipAddresses
              properties
            }
            pageInfo {
              hasNextPage
              endCursor
            }
          }
        }
      GRAPHQL

      # GraphQL query for getting a specific asset
      GET_QUERY = <<~GRAPHQL
        query GetAsset($id: ID!) {
          graphEntity(id: $id) {
            id
            name
            type
            cloudProvider
            region
            status
            createdAt
            tags {
              key
              value
            }
            ipAddresses
            properties
          }
        }
      GRAPHQL
    end
  end
end

