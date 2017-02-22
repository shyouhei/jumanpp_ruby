# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = "jumanpp_ruby"
  spec.version       = '1.0.0'
  spec.authors       = ["sho ishihara"]
  spec.email         = ["sho.ishihara@theport.jp"]

  spec.summary       = %q{This gem is Ruby binding for JUMAN++}
  spec.homepage      = 'https://github.com/EastResident/jumanpp_ruby'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "simplecov"
end
