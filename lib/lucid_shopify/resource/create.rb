# frozen_string_literal: true

module LucidShopify
  module Resource
    #
    # @abstract
    #
    class Create
      def self.new; raise NotImplementedError; end
    end
  end
end
