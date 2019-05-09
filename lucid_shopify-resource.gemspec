# frozen_string_literal: true

$LOAD_PATH.unshift "#{__dir__}/lib"

require 'lucid_shopify/resource/version'

Gem::Specification.new do |s|
  s.add_development_dependency 'rspec', '~> 3.6'
  s.add_development_dependency 'rubocop', '0.52.0'
  s.add_runtime_dependency 'lucid_shopify', '~> 0.27'
  s.author = 'Kelsey Judson'
  s.email = 'kelsey@lucid.nz'
  s.files = Dir.glob('lib/**/*') + %w(README.md)
  s.homepage = 'https://github.com/lucidnz/gem-lucid_shopify-resource'
  s.license = 'ISC'
  s.name = 'lucid_shopify-resource'
  s.summary = 'Shopify client library resource helpers'
  s.version = LucidShopify::Resource::VERSION
end
