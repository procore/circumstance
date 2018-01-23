require File.expand_path('../lib/scenario/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "circumstance"
  spec.version       = Scenario::VERSION
  spec.authors       = [
    "Manfred Stienstra",
    "Matt Casper"
  ]
  spec.email = [
    "manfred@fngtps.com",
    "matthewvcasper@gmail.com"
  ]
  spec.summary = <<-EOF
  Circumstance is a thin wrapper around test setup.
  EOF
  spec.description = <<-EOF
  Circumstance allows you to register and evaluate setup block globally in your
  test suite. This is useful when you want to share big blocks of factory
  setups between tests.
  EOF
  spec.homepage      = "http://github.com/procore/circumstance"
  spec.license       = "MIT"

  spec.files         = [
    'LICENSE.txt',
    'lib/scenario.rb',
    'lib/scenario/helpers.rb',
    'lib/scenario/registry.rb',
    'lib/scenario/version.rb'
  ]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
