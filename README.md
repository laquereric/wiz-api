# WIZ API Ruby Client

This gem provides a Ruby client library for interacting with the WIZ Cloud Security Platform's GraphQL API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wiz-api'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install wiz-api

## Usage

### Configuration

You can configure the client either directly or using a block.

**Directly:**

```ruby
require 'wiz'

client = Wiz::Client.new(
  client_id: 'your-client-id',
  client_secret: 'your-client-secret',
  api_endpoint: 'https://api.us1.app.wiz.io/graphql'
)
```

**Globally:**

```ruby
Wiz.configure do |config|
  config.client_id = ENV['WIZ_CLIENT_ID']
  config.client_secret = ENV['WIZ_CLIENT_SECRET']
  config.api_endpoint = ENV['WIZ_API_ENDPOINT']
end

client = Wiz::Client.new
```

### Querying Resources

**List Issues:**

```ruby
issues = client.issues.list(severity: 'CRITICAL', limit: 10)
issues.each do |issue|
  puts "#{issue.id}: #{issue.title} - #{issue.severity}"
end
```

**Get a Specific Issue:**

```ruby
issue = client.issues.get('issue-id')
puts issue.description
```

**List Vulnerabilities:**

```ruby
vulnerabilities = client.vulnerabilities.list(limit: 20)
vulnerabilities.each do |vuln|
  puts "#{vuln.cve_id}: #{vuln.severity}"
end
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/example/wiz-api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/example/wiz-api/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

