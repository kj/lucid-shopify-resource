# frozen_string_literal: true

require 'lucid_shopify/resource/base'

module LucidShopify
  module Resource
    #
    # @example
    #   class OrderRepository
    #     include LucidShopify::Resource::Create
    #
    #     resource :orders
    #
    #     # ...
    #   end
    #
    module Create
      def self.included(base)
        base.include(Base)
      end

      #
      # @param credentials [Credentials]
      # @param data [Hash]
      #
      # @return [Integer] the new ID
      #
      def create(credentials, data)
        response = client.post_json(credentials, resource, resource_singular => data)

        response.data_hash.dig(resource_singular, 'id').tap do |id|
          logger.info("Created #{resource_singular} id=#{id}")
        end
      end
    end
  end
end
