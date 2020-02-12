lucid-shopify-resource
======================

Installation
------------

Add the gem to your ‘Gemfile’:

    gem 'lucid-shopify'
    gem 'lucid-shopify-resource'


Usage
-----

### Create a resource

    class OrderRepository
      include Lucid::Shopify::Resource::Create

      resource :orders
    end

    order_repo = OrderRepository.new

    order_repo.create(credentials, new_order)


### Delete a resource

    class OrderRepository
      include Lucid::Shopify::Resource::Delete

      resource :orders
    end

    order_repo = OrderRepository.new

    order_repo.delete(credentials, id)


### Read a resource

Include and configure `Read`:

    class OrderRepository
      include Lucid::Shopify::Resource::Read

      resource :orders

      default_params fields: %w[id tags], limit: 250
    end

    order_repo = OrderRepository.new

    order_repo.find(credentials, id)

The `OrderRepository` class is enumerable. Each page is fetched from the API as
needed, rather than all at once:

    order_repo = OrderRepository.new

    order_repo.each(credentials) |order|
      # ...
    end


### Update a resource

    class OrderRepository
      include Lucid::Shopify::Resource::Update

      resource :orders
    end

    order_repo = OrderRepository.new

    order_repo.create(credentials, id, order)
