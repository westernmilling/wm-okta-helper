# frozen_string_literal: true

require 'net/http'
require 'uri'

module OktaJwtValidation
  class PostRequest
    def initialize(options)
      @request_body = options[:request_body]
      @url = options[:url]
    end

    def call
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(uri)
      request['Accept'] = 'application/json'
      request['Content-Type'] = 'application/json'
      request['Cache-Control'] = 'no-cache'
      request.body = request_body.to_json

      response = http.request(request)
      JSON.parse(response.read_body)
    end

    attr_accessor :request_body, :url

    private

    def uri
      URI(url)
    end
  end
end
