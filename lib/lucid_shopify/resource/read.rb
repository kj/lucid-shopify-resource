# frozen_string_literal: true

require 'lucid_shopify/resource/base'

module LucidShopify
  module Resource
    #
    # @example
    #   class OrderRepository
    #     include LucidShopify::Resource::Read
    #
    #     resource :orders
    #
    #     default_params fields: %w[id tags]
    #
    #     # ...
    #   end
    #
    module Read
      module ClassMethods
        #
        # Set the default query params. Note that 'fields' may be passed as an
        # array of strings.
        #
        # @param params [Hash]
        #
        # @example
        #   default_params fields: %w(id tags)
        #
        def default_params(params)
          define_method(:default_params) { params }
        end
      end

      include Enumerable

      def self.included(base)
        base.extend(ClassMethods)
        base.include(Base)
      end

      #
      # @abstract Use {ClassMethods#default_params} to implement (optional)
      #
      # @return [Hash]
      #
      def default_params
        {}
      end

      #
      # Defaults set by Shopify when not specified.
      #
      # @return [Hash]
      #
      def default_shopify_params
        {
          limit: 50,
        }
      end

      #
      # @param credentials [RequestCredentials]
      # @param id [Integer]
      # @param params [Hash]
      #
      # @return [Hash]
      #
      def find(credentials, id, params = {})
        params = finalized_params(params)

        client.get(credentials, "#{resource}/#{id}", params)[resource]
      end

      #
      # Iterate over results. If set, the 'fields' option must include 'id'. We
      # would not need this if we used offset pagination, but offset pagination
      # is unreliable.
      #
      # Throttling is always enabled.
      #
      # @param credentials [RequestCredentials]
      # @param params [Hash]
      #
      # @yield [Hash]
      #
      # @return [Enumerator]
      #
      # @raise [ArgumentError] if 'fields' does not include 'id'
      #
      def each(credentials, params = {})
        return to_enum(__callee__, params) unless block_given?

        assert_fields_id!(params = finalized_params(params))

        throttled_client = client.throttled

        since_id = 1

        loop do
          results = throttled_client.get(credentials, resource, params.merge(since_id: since_id))
          results.each do |result|
            yield result
          end

          break if results.empty?

          since_id = results.last['id']
        end
      end

      #
      # @param params [Hash] the finalized params (see {#finalize_params})
      #
      private def assert_fields_id!(params)
        return unless params['fields']
        return unless params['fields'] !~ /\bid\b/

        raise ArgumentError, 'attempt to paginate without id field'
      end

      #
      # @param params [Hash]
      #
      # @return [Integer]
      #
      def count(params = {})
        params = finalize_params(params)

        client.get("#{resource}/count", params)['count']
      end

      #
      # Merge with default params and format for query string.
      #
      # @param params [Hash]
      #
      # @return [Hash]
      #
      private def finalize_params(params)
        params = default_shopify_params.merge(default_params).merge(params)
        params.each_with_object({}) do |(k, v), h|
          k = k.to_s

          k == 'fields' && v.is_a?(Array) ? v.join(',') : v

          h[k] = v
        end
      end
    end
  end
end
