# frozen_string_literal: true

RSpec.describe WmOktaHelper::ValidateSession do
  describe '#call' do
    let(:request) do
      double('request2', headers: { 'Authorization' => '20111I3t5tqftiI1X70O' })
    end

    context 'with correct credentials' do
      let(:subject) do
        WmOktaHelper::ValidateSession.new(
          request: request,
          okta_org: 'westernmilling',
          okta_domain: 'okta'
        ).call
      end

      let(:fixture_file) { 'validate_session_success.json' }

      let(:response_body) do
        File.read(File.join(%W[./ spec support fixtures #{fixture_file}]))
      end

      it 'returns expected message hash' do
        stub_request(:post, 'https://westernmilling.okta.com/api/v1/sessions')
          .to_return(status: 200, body: response_body, headers: {})

        expect(subject).to eq true
      end
    end

    context 'with incorrect credentials' do
      let(:fixture_file) { 'validate_session_failure.json' }

      let(:response_body) do
        File.read(File.join(%W[./ spec support fixtures #{fixture_file}]))
      end

      let(:subject) do
        WmOktaHelper::ValidateSession.new(
          request: request,
          okta_org: 'westernmilling',
          okta_domain: 'okta'
        ).call
      end

      it 'returns expected message hash' do
        stub_request(:post, 'https://westernmilling.okta.com/api/v1/sessions')
          .to_return(status: 401, body: response_body, headers: {})

        expect(subject).to eq false
      end
    end
  end
end
