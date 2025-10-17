# frozen_string_literal: true

module Wiz
  module Models
    # Base class for all WIZ API models
    class Base
      attr_reader :raw_data

      # Initialize a new model instance
      #
      # @param data [Hash] the raw data from the API
      def initialize(data = {})
        @raw_data = data
        load_attributes(data)
      end

      # Get the ID of the resource
      #
      # @return [String, nil]
      def id
        @id
      end

      # Convert the model to a hash
      #
      # @return [Hash]
      def to_h
        raw_data
      end

      # Convert the model to JSON
      #
      # @return [String]
      def to_json(*args)
        require "json"
        to_h.to_json(*args)
      end

      private

      # Load attributes from data hash
      #
      # @param data [Hash] the data to load
      def load_attributes(data)
        @id = data["id"]
      end
    end
  end
end

