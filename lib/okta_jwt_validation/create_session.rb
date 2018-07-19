# frozen_string_literal: true

module OktaJwtValidation
  class CreateSession
    def initialize(options)
      @username = options[:username]
      @password = options[:password]
      @okta_org = options[:okta_org]
      @okta_domain = options[:okta_domain]
    end

    def call
      PostRequest.new(
        url: url,
        request_body: request_body
      ).call
    end

    attr_accessor :username, :password, :okta_org, :okta_domain

    private

    def url
      "https://#{okta_org}.#{okta_domain}.com/api/v1/authn"
    end

    def request_body
      {
        username: username,
        password: password,
        options: {
          multiOptionalFactorEnroll: true,
          warnBeforePasswordExpired: true
        }
      }
    end
  end
end
