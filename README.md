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

Subclass and configure `Read`:

    class Orders < LucidShopify::Resource::Read
      resource :orders

      default_options fields: %w(id tags), limit: 250
    end

    orders = Orders.new

    orders.find(request_credentials, id)

The `Orders` class is enumerable. Each page is fetched from the API as needed,
rather than all at once:

    orders = Orders.new

    orders.each(request_credentials) |order|
      # ...
    end


### Update a resource

_TODO: Implement when needed._
