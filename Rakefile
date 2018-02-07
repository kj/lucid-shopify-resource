$: << "#{__dir__}/lib"

require 'lucid_shopify/resource/version'

task default: :build

task :build do
  system 'gem build lucid_shopify-resource.gemspec'
end

task install: :build do
  system "gem install lucid_shopify-resource-#{LucidShopify::Resource::VERSION}.gem"
end

task :clean do
  system 'rm lucid_shopify-resource-*.gem'
end
