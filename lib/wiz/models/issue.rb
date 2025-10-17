# frozen_string_literal: true

module Wiz
  module Models
    # Represents a WIZ Issue (security finding, vulnerability, etc.)
    class Issue < Base
      attr_reader :title, :severity, :status, :type, :created_at, :updated_at,
                  :description, :remediation, :projects, :source_rule

      private

      def load_attributes(data)
        super
        @title = data["title"]
        @severity = data["severity"]
        @status = data["status"]
        @type = data["type"]
        @created_at = parse_time(data["createdAt"])
        @updated_at = parse_time(data["updatedAt"])
        @description = data["description"]
        @remediation = data["remediation"]
        @projects = data["projects"] || []
        @source_rule = data["sourceRule"]
      end

      def parse_time(time_string)
        return nil if time_string.nil?

        Time.parse(time_string)
      rescue ArgumentError
        nil
      end
    end
  end
end

