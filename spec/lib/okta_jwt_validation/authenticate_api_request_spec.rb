# frozen_string_literal: true

require 'support/test_request'

RSpec.describe OktaJwtValidation::AuthenticateApiRequest do
  describe '#call' do
    context 'with correct credentials' do
      let(:expected_request) do
        TestRequest.new
      end
      let(:okta_client_id) { 'yEqoXVxrwxFImVKHdtJF' }

      let(:subject) do
        OktaJwtValidation::AuthenticateApiRequest.new(
          request: expected_request,
          okta_org: 'westernmilling',
          okta_domain: 'okta',
          okta_client_id: okta_client_id
        ).call
      end

      it 'returns expected message hash' do
        expect(subject).to have_key('iss')
        expect(subject).to have_key('aud')
        expect(subject['aud']).to eq okta_client_id
        expect(subject['iss']).to eq 'https://westernmilling.okta.com'
        expect(Time.strptime(subject['exp'].to_s, '%s') < Time.now.utc)
      end
    end

    context 'with an incorrect client id' do
      let(:expected_request) do
        TestRequest.new
      end
      let(:okta_client_id) { 'wrong_key_here' }

      let(:subject) do
        OktaJwtValidation::AuthenticateApiRequest.new(
          request: expected_request,
          okta_org: 'westernmilling',
          okta_domain: 'okta',
          okta_client_id: okta_client_id
        ).call
      end

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end

    context 'with missing credentials' do
      let(:expected_request) do
        TestRequest.new
      end

      let(:subject) do
        OktaJwtValidation::AuthenticateApiRequest.new(
          request: expected_request,
          okta_org: '',
          okta_domain: '',
          okta_client_id: ''
        ).call
      end

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end
  end
end
