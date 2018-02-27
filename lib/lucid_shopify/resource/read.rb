# frozen_string_literal: true

module LucidShopify
  module Resource
    #
    # @abstract
    #
    # @example
    #   class Orders < LucidShopify::Resource::Read
    #     resource :orders
    #
    #     default_params fields: %w(id tags)
    #   end
    #
    class Read
      include Enumerable
      include LucidShopify

      #
      # @param client [LucidShopify::Client]
      #
      def initialize(client: Client.new(send_request: SendThrottledRequest.new))
        @client = client
      end

      # @return [LucidShopify::Client]
      attr_reader :client

      #
      # Set the remote API resource name for the subclass.
      #
      # @param resource_name [String, #to_s]
      #
      # @example
      #   resource :orders
      #
      def self.resource(resource_name)
        define_method(:resource) { resource_name.to_s }
      end

      #
      # @abstract
      #
      # @return [String]
      #
      def resource
        raise NotImplementedError
      end

      #
      # Set the default query params. Note that 'fields' may be passed as an
      # array of strings.
      #
      # @param params [Hash]
      #
      # @example
      #   default_params fields: %w(id tags)
      #
      def self.default_params(params)
        define_method(:default_params) { params }
      end

      #
      # @abstract
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
      # @param credentials [LucidShopify::RequestCredentials]
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
      # @param credentials [LucidShopify::RequestCredentials]
      # @param params [Hash]
      #
      # @yield [Hash]
      #
      # @return [Enumerator]
      #
      # @raise [ArgumentError] if 'fields' does not include 'id'
      #
      def each(credentials, params = {})
        return to_enum(__callee__) unless block_given?

        assert_fields_id!(params = finalized_params(params))

        since_id = 1

        loop do
          results = client.get(credentials, resource, params.merge(since_id: since_id))
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
      # @param client [LucidShopify::AuthorizedClient]
      # @param params [Hash]
      #
      # @return [Integer]
      #
      def count(client, params = {})
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
