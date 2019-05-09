# frozen_string_literal: true

require 'lucid_shopify/resource/base'

module LucidShopify
  module Resource
    #
    # @example
    #   class OrderRepository
    #     include LucidShopify::Resource::Update
    #
    #     resource :orders
    #
    #     # ...
    #   end
    #
    module Update
      def self.included(base)
        base.include(Base)
      end

      #
      # @param credentials [Credentials]
      # @param id [Integer]
      # @param data [Hash]
      #
      def update(credentials, id, data)
        client.put_json(credentials, "#{resource}/#{id}", resource_singular => data)
      end
    end
  end
end
