# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rest-more-yahoo_buy/version'

Gem::Specification.new do |spec|
  spec.name          = "rest-more-yahoo_buy"
  spec.version       = RestMore::YahooBuy::VERSION
  spec.authors       = ["GoodLife", "lulalala"]
  spec.email         = ["mark@goodlife.tw"]
  spec.description   = "Yahoo!奇摩購物中心 client built with [rest-core][].\n\n[rest-core]: https://github.com/cardinalblue/rest-core"
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/lulalala/rest-more-yahoo_buy"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  if spec.respond_to? :specification_version then
    spec.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      spec.add_runtime_dependency(%q<rest-core>, [">= 2.0.3"])
    else
      spec.add_dependency(%q<rest-core>, [">= 2.0.3"])
    end
  else
    spec.add_dependency(%q<rest-core>, [">= 2.0.3"])
  end
  spec.add_dependency 'crack'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
