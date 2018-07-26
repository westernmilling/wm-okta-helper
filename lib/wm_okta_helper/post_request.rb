# frozen_string_literal: true

require 'addressable/uri'
require 'net/http'
require 'uri'

module WmOktaHelper
  class PostRequest
    def initialize(options)
      @request_body = options[:request_body]
      @url = options[:url]
      @schemes = %w[http https].freeze
    end

    def call
      return invalid_url unless valid_url?(url)
      post_request
    end

    protected

    def post_request
      http = Net::HTTP.new(uri.host, uri.port)
      open_ssl(http) if parsed.scheme == 'https'

      response = http.request(request_configuration)
      JSON.parse(response.read_body)
    end

    def uri
      URI(url)
    end

    def request_configuration
      request = Net::HTTP::Post.new(uri)
      request['Accept'] = 'application/json'
      request['Content-Type'] = 'application/json'
      request['Cache-Control'] = 'no-cache'
      request.body = request_body.to_json
      request
    end

    def parsed
      Addressable::URI.parse(uri) or return false
    end

    def valid_url?(parsed)
      schemes.include?(
        parsed.scan(URI::DEFAULT_PARSER.make_regexp)[0][0]
      )
    rescue Addressable::URI::InvalidURIError
      false
    end

    def invalid_url
      {
        "errors": [
          "The url #{url} is not valid"
        ]
      }
    end

    def open_ssl(http)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http
    end

    attr_accessor :request_body, :url, :schemes
  end
end
