# frozen_string_literal: true

require 'logger'

require 'lucid_shopify/container'

module LucidShopify
  module Resource
    module Base
      module ClassMethods
        #
        # Set the remote API resource name for the subclass.
        #
        # @param resource_name [String, #to_s]
        #
        # @example
        #   resource :orders
        #
        def resource(resource_name)
          define_method(:resource) { resource_name.to_s }
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
      # @return [Client]
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
