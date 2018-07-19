# frozen_string_literal: true

RSpec.describe OktaJwtValidation::CreateSession do
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
      def mock_user
        user = double('user', id: 1,
                              username: 'Test User',
                              password: 'long_convoluted_password')

        user
      end

      before do
        mock_user
      end

      let(:username) do
        mock_user.username
      end

      let(:password) do
        mock_user.password
      end

      let(:subject) do
        OktaJwtValidation::CreateSession.new(
          username: username,
          password: password,
          okta_org: 'westernmilling',
          okta_domain: 'okta'
        ).call
      end

      let(:request_body) do
        { username: 'Test User',
          password: 'long_convoluted_password',
          options: {
            multiOptionalFactorEnroll: true,
            warnBeforePasswordExpired: true
          } }.to_json
      end

      let(:full_request) do
        { body: request_body,
          headers: request_headers }
      end

      let(:fixture_file) { 'create_session_success.json' }

      let(:response_body) do
        File.read(File.join(%W[./ spec support fixtures #{fixture_file}]))
      end

      it 'returns expected message hash' do
        stub_request(:post, 'https://westernmilling.okta.com/api/v1/authn')
          .with(full_request)
          .to_return(status: 200, body: response_body, headers: {})

        expect(
          JSON.parse(subject)
        ).to have_key('sessionToken')
        expect(
          JSON.parse(subject)
        ).to have_key('status')
      end
    end

    context 'with incorrect credentials' do
      def mock_user
        user = double('user', id: 1,
                              username: 'Test User',
                              password: 'oh_bad_password_are_thee')

        user
      end

      before do
        mock_user
      end

      let(:username) do
        mock_user.username
      end

      let(:password) do
        mock_user.password
      end

      let(:subject) do
        OktaJwtValidation::CreateSession.new(
          username: username,
          password: password,
          okta_org: 'westernmilling',
          okta_domain: 'okta'
        ).call
      end

      let(:request_body) do
        { username: 'Test User',
          password: 'oh_bad_password_are_thee',
          options: {
            multiOptionalFactorEnroll: true,
            warnBeforePasswordExpired: true
          } }.to_json
      end

      let(:full_request) do
        {
          body: request_body,
          headers: request_headers
        }
      end

      let(:fixture_file) { 'create_session_failure.json' }

      let(:response_body) do
        File.read(File.join(%W[./ spec support fixtures #{fixture_file}]))
      end

      it 'returns expected error hash' do
        stub_request(:post, 'https://westernmilling.okta.com/api/v1/authn')
          .with(full_request)
          .to_return(status: 401, body: response_body, headers: {})

        expect(
          JSON.parse(subject.to_json)
        ).to have_key('errorCode')
        expect(
          JSON.parse(subject.to_json)
        ).to have_key('errorSummary')
      end
    end
  end
end
