# frozen_string_literal: true

require 'lucid_shopify/resource/base'

module LucidShopify
  module Resource
    #
    # @example
    #   class OrderRepository
    #     include LucidShopify::Resource::Delete
    #
    #     resource :orders
    #
    #     # ...
    #   end
    #
    module Delete
      def self.included(base)
        base.include(Base)
      end

      #
      # @param credentials [Credentials]
      # @param id [Integer]
      #
      def delete(credentials, id)
        client.delete(credentials, "#{resource}/#{id}").tap do
          logger.info("Deleted #{resource_singular} id=#{id}")
        end
      end
    end
  end
end
