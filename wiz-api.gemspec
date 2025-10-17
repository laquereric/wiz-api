# frozen_string_literal: true

require_relative "lib/wiz/version"

Gem::Specification.new do |spec|
  spec.name = "wiz-api"
  spec.version = Wiz::VERSION
  spec.authors = ["WIZ API Client"]
  spec.email = ["dev@example.com"]

  spec.summary = "Ruby client library for the WIZ Cloud Security Platform API"
  spec.description = "A comprehensive Ruby gem for interacting with the WIZ GraphQL API, providing easy access to cloud security data including issues, vulnerabilities, and assets."
  spec.homepage = "https://github.com/example/wiz-api"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/example/wiz-api"
  spec.metadata["changelog_uri"] = "https://github.com/example/wiz-api/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob(%w[
    lib/**/*.rb
    LICENSE
    README.md
    CHANGELOG.md
  ])
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Runtime dependencies
  spec.add_dependency "faraday", "~> 2.0"
  spec.add_dependency "faraday-retry", "~> 2.0"

  # Development dependencies
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "cucumber", "~> 9.0"
  spec.add_development_dependency "webmock", "~> 3.0"
  spec.add_development_dependency "vcr", "~> 6.0"
  spec.add_development_dependency "simplecov", "~> 0.22"
  spec.add_development_dependency "rubocop", "~> 1.0"
  spec.add_development_dependency "yard", "~> 0.9"
end

