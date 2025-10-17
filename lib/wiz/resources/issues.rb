# frozen_string_literal: true

module Wiz
  module Resources
    # Client for interacting with WIZ Issues
    class Issues < Base
      # List issues with optional filters
      #
      # @param severity [String, Array<String>] filter by severity (CRITICAL, HIGH, MEDIUM, LOW, INFORMATIONAL)
      # @param status [String, Array<String>] filter by status (OPEN, IN_PROGRESS, RESOLVED, REJECTED)
      # @param limit [Integer] maximum number of results (default: 50)
      # @param cursor [String] pagination cursor
      # @return [Array<Models::Issue>] array of issues
      #
      # @example
      #   issues = client.issues.list(severity: 'CRITICAL', limit: 10)
      def list(severity: nil, status: nil, limit: 50, cursor: nil)
        variables = pagination_params(limit: limit, cursor: cursor)
        variables[:filterBy] = build_filter(severity: severity, status: status)

        data = http.query(LIST_QUERY, variables: variables)
        nodes = extract_nodes(data, "issues")

        nodes.map { |node| Models::Issue.new(node) }
      end

      # Get a specific issue by ID
      #
      # @param id [String] the issue ID
      # @return [Models::Issue] the issue
      # @raise [NotFoundError] if the issue is not found
      #
      # @example
      #   issue = client.issues.get('issue-id')
      def get(id)
        raise MissingParameterError, "id is required" if id.nil? || id.empty?

        variables = { id: id }
        data = http.query(GET_QUERY, variables: variables)

        raise NotFoundError, "Issue not found: #{id}" unless data && data["issue"]

        Models::Issue.new(data["issue"])
      end

      private

      # Build filter parameters
      #
      # @param severity [String, Array<String>] severity filter
      # @param status [String, Array<String>] status filter
      # @return [Hash] filter parameters
      def build_filter(severity: nil, status: nil)
        filter = {}

        if severity
          filter[:severity] = Array(severity)
        end

        if status
          filter[:status] = Array(status)
        end

        filter.empty? ? nil : filter
      end

      # GraphQL query for listing issues
      LIST_QUERY = <<~GRAPHQL
        query ListIssues($first: Int, $after: String, $filterBy: IssueFilters) {
          issues(first: $first, after: $after, filterBy: $filterBy) {
            nodes {
              id
              title
              severity
              status
              type
              createdAt
              updatedAt
              description
              remediation
              projects
              sourceRule {
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

      # GraphQL query for getting a specific issue
      GET_QUERY = <<~GRAPHQL
        query GetIssue($id: ID!) {
          issue(id: $id) {
            id
            title
            severity
            status
            type
            createdAt
            updatedAt
            description
            remediation
            projects
            sourceRule {
              id
              name
            }
          }
        }
      GRAPHQL
    end
  end
end

