# frozen_string_literal: true

module LucidShopify
  module Resource
    RSpec.describe Read do
      subject(:order_repo) do
        Class.new do
          include Read

          resource :orders

          default_params %w[id tags]
        end

        # TODO: .new(client: client_double)
      end
    end
  end
end
