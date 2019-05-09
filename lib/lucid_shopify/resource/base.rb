# frozen_string_literal: true

require 'logger'

require 'lucid_shopify/container'

module LucidShopify
  module Resource
    module Base
      module ClassMethods
        #
        # Set the remote API resource name for the subclass. If a singular
        # is not provided, the plural will be used, without any trailing 's'.
        #
        # @param resource_plural [String, #to_s]
        # @param resource_singular [String, #to_s, nil]
        #
        # @example
        #   resource :orders
        #
        def resource(resource_plural, resource_singular = nil)
          define_method(:resource) { resource_name.to_s }
          define_method(:resource_singular) do
            resource_singular.nil? ? resource_plural.to_s.sub(/s$/, '') : resource_singular.to_s
          end
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

      #
      # @param client [Client]
      # @param logger [Logger]
      #
      def initialize(client: Container[:client],
                     logger: Logger.new(IO::NULL))
        @client = client
        @logger = logger
      end

      # @return [Client]
      attr_reader :client
      # @return [Logger]
      attr_reader :logger

      #
      # @abstract Use {ClassMethods#resource} to implement (required)
      #
      # @return [String]
      #
      def resource
        raise NotImplementedError
      end
    end
  end
end
