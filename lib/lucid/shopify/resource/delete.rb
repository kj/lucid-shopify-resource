# frozen_string_literal: true

require 'lucid/shopify/resource/base'

module Lucid
  module Shopify
    module Resource
      # @example
      #   class OrderRepository
      #     include Lucid::Shopify::Resource::Delete
      #
      #     resource :orders
      #
      #     # ...
      #   end
      module Delete
        # @param base [Class, Module]
        def self.included(base)
          base.include(Base)
        end

        # @param credentials [Credentials]
        # @param id [Integer]
        def delete(credentials, id)
          client.delete(credentials, "#{resource}/#{id}").tap do
            logger.info("Deleted #{resource_singular} id=#{id}")
          end
        end
      end
    end
  end
end
