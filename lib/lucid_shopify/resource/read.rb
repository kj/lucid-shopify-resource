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
    #     default_options fields: %w(id tags)
    #   end
    #
    class Read
      include Enumerable

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
      # Set the default query options. Note that 'fields' may be passed as an
      # array of strings.
      #
      # @param options [Hash]
      #
      # @example
      #   default_options fields: %w(id tags)
      #
      def self.default_options(options)
        define_method(:default_options) { options }
      end

      #
      # @abstract
      #
      # @return [Hash]
      #
      def default_options
        {}
      end

      #
      # Defaults set by Shopify when not specified.
      #
      # @return [Hash]
      #
      def default_shopify_options
        {
          limit: 50
        }
      end

      #
      # @param client [LucidShopify::AuthorizedClient]
      # @param id [Integer]
      # @param options [Hash]
      #
      # @return [Hash]
      #
      def find(client, id, options = {})
        options = finalized_options(options)

        client.get("#{resource}/#{id}", options)[resource]
      end

      #
      # Iterate over results. If set, the 'fields' option must include 'id'. We
      # would not need this if we used offset pagination, but offset pagination
      # is unreliable.
      #
      # Throttling is always enabled.
      #
      # @param client [LucidShopify::AuthorizedClient]
      # @param options [Hash]
      #
      # @yield [Hash]
      #
      # @return [Enumerator]
      #
      # @raise [ArgumentError] if 'fields' does not include 'id'
      #
      def each(client, options = {})
        return to_enum(__callee__) unless block_given?

        assert_fields_id!(options = finalized_options(options))

        since_id = 1

        loop do
          results = client.throttled.get(resource, options.merge(since_id: since_id)
          results.each do |result|
            yield result
          end

          break if results.empty?

          since_id = results.last['id']
        end
      end

      #
      # @param options [Hash] the finalized options (see {#finalize_options})
      #
      private def assert_fields_id!(options)
        return unless options['fields']
        return unless options['fields'] !~ /\bid\b/

        raise ArgumentError, 'attempt to paginate without id field'
      end

      #
      # @param client [LucidShopify::AuthorizedClient]
      # @param options [Hash]
      #
      # @return [Integer]
      #
      def count(client, options = {})
        options = finalize_options(options)

        client.get("#{resource}/count", options)['count']
      end

      #
      # Merge with default options and format for query string.
      #
      # @param options [Hash]
      #
      # @return [Hash]
      #
      private def finalize_options(options)
        options = default_shopify_options.merge(default_options).merge(options)
        options.each_with_object({}) do |(k, v), h|
          k = k.to_s

          k == 'fields' && v.is_a?(Array) ? v.join(',') : v
            
          h[k] = v
        end
      end
    end
  end
end
