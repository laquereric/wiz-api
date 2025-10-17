# frozen_string_literal: true

module Wiz
  module Resources
    # Client for interacting with WIZ Vulnerabilities
    class Vulnerabilities < Base
      # List vulnerabilities with optional filters
      #
      # @param severity [String, Array<String>] filter by severity
      # @param limit [Integer] maximum number of results (default: 50)
      # @param cursor [String] pagination cursor
      # @return [Array<Models::Vulnerability>] array of vulnerabilities
      #
      # @example
      #   vulnerabilities = client.vulnerabilities.list(severity: 'CRITICAL', limit: 20)
      def list(severity: nil, limit: 50, cursor: nil)
        variables = pagination_params(limit: limit, cursor: cursor)
        variables[:filterBy] = build_filter(severity: severity) if severity

        data = http.query(LIST_QUERY, variables: variables)
        nodes = extract_nodes(data, "vulnerabilityFindings")

        nodes.map { |node| Models::Vulnerability.new(node) }
      end

      # Get a specific vulnerability by ID
      #
      # @param id [String] the vulnerability ID
      # @return [Models::Vulnerability] the vulnerability
      # @raise [NotFoundError] if the vulnerability is not found
      #
      # @example
      #   vulnerability = client.vulnerabilities.get('vuln-id')
      def get(id)
        raise MissingParameterError, "id is required" if id.nil? || id.empty?

        variables = { id: id }
        data = http.query(GET_QUERY, variables: variables)

        raise NotFoundError, "Vulnerability not found: #{id}" unless data && data["vulnerabilityFinding"]

        Models::Vulnerability.new(data["vulnerabilityFinding"])
      end

      private

      # Build filter parameters
      #
      # @param severity [String, Array<String>] severity filter
      # @return [Hash] filter parameters
      def build_filter(severity: nil)
        filter = {}
        filter[:severity] = Array(severity) if severity
        filter
      end

      # GraphQL query for listing vulnerabilities
      LIST_QUERY = <<~GRAPHQL
        query ListVulnerabilities($first: Int, $after: String, $filterBy: VulnerabilityFindingFilters) {
          vulnerabilityFindings(first: $first, after: $after, filterBy: $filterBy) {
            nodes {
              id
              name
              severity
              cvssScore
              cveId
              detectedAt
              description
              remediation
              vendorSeverity
              affectedAssets {
                id
                name
              }
            }
            pageInfo {
              hasNextPage
              endCursor
            }
          }
        }
      GRAPHQL

      # GraphQL query for getting a specific vulnerability
      GET_QUERY = <<~GRAPHQL
        query GetVulnerability($id: ID!) {
          vulnerabilityFinding(id: $id) {
            id
            name
            severity
            cvssScore
            cveId
            detectedAt
            description
            remediation
            vendorSeverity
            affectedAssets {
              id
              name
            }
          }
        }
      GRAPHQL
    end
  end
end

