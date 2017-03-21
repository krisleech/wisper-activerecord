# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wisper/active_record/version'

Gem::Specification.new do |spec|
  spec.name          = "wisper-activerecord"
  spec.version       = Wisper::ActiveRecord::VERSION
  spec.authors       = ["Kris Leech"]
  spec.email         = ["kris.leech@gmail.com"]
  spec.summary       = %q{Subscribe to changes on ActiveRecord models}
  spec.description   = %q{Subscribe to changes on ActiveRecord models}
  spec.homepage      = "https://github.com/krisleech/wisper-activerecord"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 1.9.3"

  spec.add_dependency "wisper", "~> 2.0"
  spec.add_dependency "activerecord", ">= 3.0.0"
end
