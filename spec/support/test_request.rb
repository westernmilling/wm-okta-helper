# frozen_string_literal: true

class TestRequest
  def initialize
    @private_key = OpenSSL::PKey::RSA.generate(2048)
    @public_key = @private_key.public_key
    @kid = @public_key.to_jwk['kid']
    @id_token = JWT.encode payload, @private_key, 'RS256', typ: 'JWT', kid: @kid

    Rails.cache.write(
      'OKTA_PUBLIC_KEYS', {
        @kid => @public_key.to_jwk.except('alg')
      }, expires_in: 3.months
    )
  end

  attr_reader :kid, :public_key, :key, :id_token

  def payload
    {
      'iss': 'https://westernmilling.okta.com',
      'sub': SecureRandom.uuid,
      'aud': 'yEqoXVxrwxFImVKHdtJF',
      'exp': (Time.current + 1.month).to_i,
      'name': 'Sam Adams',
      'email': 'sam@adams.com',
      'iat': Time.current.to_i
    }
  end

  def headers
    {
      'Accept' => 'application/json',
      'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Host' => 'westernmilling.okta.com',
      'User-Agent' => 'Ruby',
      'Authorization' => id_token
    }
  end
end
