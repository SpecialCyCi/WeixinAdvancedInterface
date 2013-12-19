# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'weixin_advanced_interface/version'

Gem::Specification.new do |spec|
  spec.name          = "weixin_advanced_interface"
  spec.version       = WeixinAdvancedInterface::VERSION
  spec.authors       = ["Special Leung"]
  spec.email         = ["specialcyci@gmail.com"]
  spec.description   = %q{微信高级接口调用}
  spec.summary       = %q{微信高级接口调用}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
