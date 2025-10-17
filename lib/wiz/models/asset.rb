# frozen_string_literal: true

module Wiz
  module Models
    # Represents a WIZ Cloud Asset (VM, container, etc.)
    class Asset < Base
      attr_reader :name, :type, :cloud_provider, :region, :status,
                  :created_at, :tags, :ip_addresses, :properties

      private

      def load_attributes(data)
        super
        @name = data["name"]
        @type = data["type"]
        @cloud_provider = data["cloudProvider"]
        @region = data["region"]
        @status = data["status"]
        @created_at = parse_time(data["createdAt"])
        @tags = data["tags"] || []
        @ip_addresses = data["ipAddresses"] || []
        @properties = data["properties"] || {}
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

