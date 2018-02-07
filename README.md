lucid_shopify-resource
======================

Installation
------------

Add the following lines to your ‘Gemfile’:

    git_source :lucid { |r| "https://github.com/lucidnz/gem-lucid_#{r}.git" }

    gem 'lucid_shopify-resource', lucid: 'shopify-resource'


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

    orders.find(client, id)

The `Orders` class is enumerable. Each page is fetched from the API as needed,
rather than all at once:

    orders = Orders.new

    orders.each(client) |order|
      # ...
    end


### Update a resource

_TODO: Implement when needed._
