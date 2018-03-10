
Gem::Specification.new do |spec|
  spec.name          = "embulk-input-ffaker"
  spec.version       = "0.1.0"
  spec.summary       = "Fake input plugin for Embulk"
  spec.description   = "Loads records from Fake."
  spec.licenses      = ["MIT"]
  # TODO set this: spec.homepage      = "https://github.com/hara/embulk-input-ffaker"

  spec.files         = `git ls-files`.split("\n") + Dir["classpath/*.jar"]
  spec.test_files    = spec.files.grep(%r{^(test|spec)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'ffaker'
  spec.add_development_dependency 'embulk', ['>= 0.9.4']
  spec.add_development_dependency 'bundler', ['>= 1.10.6']
  spec.add_development_dependency 'rake', ['>= 10.0']
end
