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

        raise NotImplementedError # TODO
      end
    end
  end
end
