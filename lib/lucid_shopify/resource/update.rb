# frozen_string_literal: true

module LucidShopify
  module Resource
    #
    # @abstract
    #
    class Update
      def self.new; raise NotImplementedError; end
    end
  end
end
