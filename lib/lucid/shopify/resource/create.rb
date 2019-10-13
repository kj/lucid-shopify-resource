# frozen_string_literal: true

require 'lucid/shopify/resource/base'

module Lucid
  module Shopify
    module Resource
      # @example
      #   class OrderRepository
      #     include Lucid::Shopify::Resource::Create
      #
      #     resource :orders
      #
      #     # ...
      #   end
      module Create
        # @param base [Class, Module]
        def self.included(base)
          base.include(Base)
        end

        # @param credentials [Credentials]
        # @param data [Hash]
        #
        # @return [Integer] the new ID
        def create(credentials, data)
          data = client.post_json(credentials, resource, resource_singular => data).to_h

          data.dig(resource_singular, 'id').tap do |id|
            logger.info("Created #{resource_singular} id=#{id}")
          end
        end
      end
    end
  end
end
