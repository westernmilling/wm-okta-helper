# okta_jwt_validation


Workflow:
 - User using an App authenticates through front end using his own Okta credentials.
 - User calls App API sending id token
 - App uses gem to validate id token

**If the wrapper is needed**
 - App uses gem to get session token
 - App calls Wm-mssql-wrapper  passing session token
 - Wm-mssql-wrapper uses gem to validate session token.

The only App knowledge about Okta is the Figaro parameters.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'okta_jwt_validation'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install okta_jwt_validation

## Usage

How to use:

```ruby
      token = OktaJwtValidation::AuthenticateApiRequest.new(
        request: request,
        okta_org: Figaro.env.OKTA_ORG,
        okta_domain: Figaro.env.OKTA_DOMAIN,
        okta_client_id: Figaro.env.OKTA_CLIENT_ID
      ).call
```

Where request is Rails ActionDispatch::Request to request a token.

The response is a signed [JSON Web Signature](https://github.com/nov/json-jwt/wiki/JWS).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/okta_jwt_validation. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the okta_jwt_validation project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/okta_jwt_validation/blob/master/CODE_OF_CONDUCT.md).





