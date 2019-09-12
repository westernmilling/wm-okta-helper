# frozen_string_literal: true

require 'net/http'

module WmOktaHelper
  class GetUserGroups
    def initialize(options)
      @user = options[:user]
      @okta_org = options[:okta_org]
      @okta_domain = options[:okta_domain]
      @api_key = options[:api_key]
    end

    def call
      okta_groups
    end

    private

    def site
      "https://#{@okta_org}.#{@okta_domain}.com"
    end

    def endpoint
      "api/v1/users/#{@user}/groups"
    end

    def request_url
      URI("#{site}/#{endpoint}")
    end

    def okta_groups
      groups = []
      fetch_data.each do |g|
        group_name = g.dig('profile', 'name')
        groups << group_name if group_name.include?('otto_')
      end
      groups
    end

    def fetch_data
      uri = URI.parse(site)
      req_options = { use_ssl: uri.scheme == 'https' }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
      response.body.present? ? JSON.parse(response.body) : []
    end

    def request
      @request ||= Net::HTTP::Get.new(request_url)
      @request.content_type = 'application/json'
      @request['Accept'] = 'application/json'
      @request['Authorization'] = "SSWS #{@api_key}"
      @request
    end
  end
end
