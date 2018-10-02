# frozen_string_literal: true

module WmOktaHelper
  class CreateSession
    def initialize(options)
      @options = options
    end

    def call
      raise 'Not authorized' if response['sessionToken'].blank?
      response
    end

    attr_accessor :username, :password, :okta_org, :okta_domain

    private

    def available_options
      %i[username password okta_org okta_domain]
    end

    def check_options
      missing_options = available_options.select { |o| @options[o].blank? }
      if missing_options.present?
        raise "Missing configuration variable: #{missing_options}"
      end
      available_options.each do |o|
        instance_variable_set("@#{o}", @options[o])
      end
    end

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

    def response
      @response ||= PostRequest.new(
        url: url,
        request_body: request_body
      ).call
    end
  end
end
