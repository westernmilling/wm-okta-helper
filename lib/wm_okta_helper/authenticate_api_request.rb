# frozen_string_literal: true

require 'json/jwt'
require 'jwt'
require 'net/http'

module WmOktaHelper
  class AuthenticateApiRequest
    def initialize(options)
      @request = options[:request]
      @token = nil
      @okta_org = options[:okta_org]
      @okta_domain = options[:okta_domain]
      @okta_client_id = options[:okta_client_id]
    end

    def call
      authenticate_request
    end

    attr_accessor :request, :okta_org, :okta_domain, :okta_client_id

    private

    def cache_key
      'OKTA_PUBLIC_KEYS'
    end

    def site
      "https://#{okta_org}.#{okta_domain}.com"
    end

    def authenticate_request
      @token if token_valid?
    end

    def client_id
      okta_client_id
    end

    def dirty_kid
      dirty_token.last['kid']
    end

    def dirty_token
      JWT.decode(request_token, nil, false)
    end

    def okta_keys
      Rails.cache.fetch(cache_key, expires_in: 1.month) do
        Rails.logger.info('Okta keys cache miss')
        okta_keys = {}
        uri = URI("#{site}/oauth2/v1/keys")
        data = Net::HTTP.get(uri)
        keys = JSON.parse(data)
        keys['keys'].each { |k| okta_keys[k['kid']] = k.except('alg') }
        okta_keys
      end
    end

    def parse_token
      JSON::JWT.decode request_token, public_key
    rescue StandardError
      JSON::JWT.decode request_token, public_key(true)
    end

    def public_key(clear_cache = false)
      Rails.cache.delete(cache_key) if clear_cache
      JSON::JWK.new(okta_keys[dirty_kid])
    end

    def request_token
      @request.headers['Authorization']
    end

    def token_valid?
      @token = parse_token
      return false if check_token

      true
    end

    def check_token
      @token['iss'] != site ||
        @token['aud'] != client_id ||
        (@token['exp'].to_i < Time.now.utc.to_i && Rails.env != 'react_test')
    end
  end
end
