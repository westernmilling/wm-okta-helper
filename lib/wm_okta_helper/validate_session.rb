# frozen_string_literal: true

module WmOktaHelper
  class ValidateSession
    def initialize(options)
      @request_object = options[:request]
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

    attr_accessor :request_object, :okta_org, :okta_domain

    private

    def url
      "https://#{okta_org}.#{okta_domain}.com/api/v1/sessions"
    end

    def request_body
      { sessionToken: request_object.headers['Authorization'] }
    end
  end
end
