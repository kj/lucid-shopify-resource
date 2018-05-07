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

        raise NotImplementedError # TODO
      end
    end
  end
end
