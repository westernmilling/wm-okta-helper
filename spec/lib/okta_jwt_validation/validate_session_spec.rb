# frozen_string_literal: true

RSpec.describe OktaJwtValidation::ValidateSession do
  describe '#call' do
    let(:request_headers) do
      {
        'Accept' => 'application/json',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Cache-Control' => 'no-cache',
        'Content-Type' => 'application/json',
        'Host' => 'westernmilling.okta.com',
        'User-Agent' => 'Ruby'
      }
    end
    context 'with correct credentials' do
      let(:session_token) do
        '20111I3t5tqftiI1X70O'
      end

      let(:subject) do
        OktaJwtValidation::ValidateSession.new(
          sessionToken: session_token,
          okta_org: 'westernmilling',
          okta_domain: 'okta'
        ).call
      end

      let(:full_request) do
        { body: '{"sessionToken":"20111I3t5tqftiI1X70O"}',
          headers: request_headers }
      end

      let(:fixture_file) { 'validate_session_success.json' }

      let(:response_body) do
        File.read(File.join(%W[./ spec support fixtures #{fixture_file}]))
      end

      it 'returns expected message hash' do
        stub_request(:post, 'https://westernmilling.okta.com/api/v1/sessions')
          .with(full_request)
          .to_return(status: 200, body: response_body, headers: {})

        expect(subject).to eq true
      end
    end
    context 'with incorrect credentials' do
      let(:session_token) do
        'such_a_bad_token'
      end
      let(:fixture_file) { 'validate_session_failure.json' }

      let(:response_body) do
        File.read(File.join(%W[./ spec support fixtures #{fixture_file}]))
      end

      let(:subject) do
        OktaJwtValidation::ValidateSession.new(
          sessionToken: session_token,
          okta_org: 'westernmilling',
          okta_domain: 'okta'
        ).call
      end

      it 'returns expected message hash' do
        stub_request(:post, 'https://westernmilling.okta.com/api/v1/sessions')
          .with(
            body: '{"sessionToken":"such_a_bad_token"}',
            headers: request_headers
          )
          .to_return(status: 401, body: response_body, headers: {})

        expect(subject).to eq false
      end
    end
  end
end
