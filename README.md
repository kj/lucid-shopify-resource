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

_TODO: Implement when needed._


### Delete a resource

_TODO: Implement when needed._


### Read a resource

Include and configure `Read`:

    class OrderRepository
      include LucidShopify::Resource::Read

      resource :orders

      default_options fields: %w(id tags), limit: 250
    end

    orders = Orders.new

    orders.find(request_credentials, id)

The `OrderRepository` class is enumerable. Each page is fetched
from the API as needed, rather than all at once:

    order_repo = OrderRepository.new

    order_repo.each(request_credentials) |order|
      # ...
    end


### Update a resource

_TODO: Implement when needed._
