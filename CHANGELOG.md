# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-10-17

### Added
- Initial release of the WIZ API Ruby client
- OAuth2 client credentials authentication flow
- GraphQL API client with automatic token management
- Resources for Issues, Vulnerabilities, and Assets
- Model classes for API responses
- Comprehensive error handling
- RSpec test suite
- Cucumber BDD support
- Documentation and examples

### Features
- List and get Issues with filtering by severity and status
- List and get Vulnerabilities with filtering by severity
- List and get Assets with filtering by cloud provider and type
- Custom GraphQL query and mutation support
- Automatic request retries for transient failures
- Configurable timeout and logging
- Global and per-client configuration options

