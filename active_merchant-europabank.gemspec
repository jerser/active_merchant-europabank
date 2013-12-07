Gem::Specification.new do |s|
  s.name        = "active_merchant-europabank"
  s.version     = "0.0.1"
  s.date        = "2013-12-06"
  s.summary     = "ActiveMerchant Integration for Europabank MPI"
  s.description = "ActiveMerchant Integration for Europabank MPI <https://www.europabank.be/ecommerce-professioneel>"
  s.authors     = ["Jeroen Serpieters"]
  s.email       = "jeroen@serpieters.be"
  s.homepage    = "https://github.com/jerser/active_merchant-europabank"
  s.license     = "MIT"

  s.files         = Dir["lib/**/*"]
  s.test_files    = Dir["test/**/*_test.rb"]
  s.require_paths = ["lib"]

  s.add_runtime_dependency "activemerchant"
end
