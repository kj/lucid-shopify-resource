lucid_shopify-resource
======================

Installation
------------

Add the gem to your ‘Gemfile’:

    gem 'lucid_shopify'
    gem 'lucid_shopify-resource'


Usage
-----

### Create a resource

    class OrderRepository
      include LucidShopify::Resource::Create

      resource :orders
    end

    order_repo = OrderRepository.new

    order_repo.create(credentials, new_order)


### Delete a resource

    class OrderRepository
      include LucidShopify::Resource::Delete

      resource :orders
    end

    order_repo = OrderRepository.new

    order_repo.delete(credentials, id)


### Read a resource

Include and configure `Read`:

    class OrderRepository
      include LucidShopify::Resource::Read

      resource :orders

      default_params fields: %w[id tags], limit: 250
    end

    order_repo = OrderRepository.new

    order_repo.find(credentials, id)

The `OrderRepository` class is enumerable. Each page is fetched
from the API as needed, rather than all at once:

    order_repo = OrderRepository.new

    order_repo.each(credentials) |order|
      # ...
    end


### Update a resource

    class OrderRepository
      include LucidShopify::Resource::Update

      resource :orders
    end

    order_repo = OrderRepository.new

    order_repo.create(credentials, id, order)
