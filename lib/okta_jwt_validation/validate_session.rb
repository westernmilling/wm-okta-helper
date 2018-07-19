# frozen_string_literal: true

module OktaJwtValidation
  class ValidateSession
    def initialize(options)
      @session_token = options[:sessionToken]
      @okta_org = options[:okta_org]
      @okta_domain = options[:okta_domain]
    end

    def call
      token = PostRequest.new(
        url: url,
        request_body: request_body
      ).call

      token['userId'].present?
    end

    attr_accessor :session_token, :okta_org, :okta_domain

    private

    def url
      "https://#{okta_org}.#{okta_domain}.com/api/v1/sessions"
    end

    def request_body
      { sessionToken: session_token }
    end
  end
end
