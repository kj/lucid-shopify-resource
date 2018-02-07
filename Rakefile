# frozen_string_literal: true

$LOAD_PATH << "#{__dir__}/lib"

require 'lucid_shopify/resource/version'

task(default: :build)
task(:build) { system 'gem build lucid_shopify-resource.gemspec' }
task(install: :build) { system "gem install lucid_shopify-resource-#{LucidShopify::Resource::VERSION}.gem" }
task(:clean) { system 'rm lucid_shopify-resource-*.gem' }
