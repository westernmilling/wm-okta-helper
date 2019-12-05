# frozen_string_literal: true

require 'support/test_request'

RSpec.describe WmOktaHelper::AuthenticateApiRequest do
  describe '#call' do
    context 'with correct credentials' do
      let(:expected_request) do
        TestRequest.new
      end

      let(:okta_client_id) { 'yEqoXVxrwxFImVKHdtJF' }

      let(:subject) do
        WmOktaHelper::AuthenticateApiRequest.new(
          request: expected_request,
          okta_org: 'westernmilling',
          okta_domain: 'okta',
          okta_client_id: okta_client_id
        ).call
      end

      it 'returns expected message hash' do
        Timecop.freeze do
          result = subject
          expect(result).to have_key('iss')
          expect(result).to have_key('aud')
          expect(result['aud']).to eq okta_client_id
          expect(result['iss']).to eq 'https://westernmilling.okta.com'
          expect(subject['exp'].to_i).to eq((Time.now.utc + 1.month).to_i)
        end
      end
    end

    context 'with an incorrect client id' do
      let(:expected_request) do
        TestRequest.new
      end
      let(:okta_client_id) { 'wrong_key_here' }

      let(:subject) do
        WmOktaHelper::AuthenticateApiRequest.new(
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
        WmOktaHelper::AuthenticateApiRequest.new(
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

    context 'with expired token' do
      let(:expected_request) do
        TestRequest.new
      end

      let(:okta_client_id) { 'yEqoXVxrwxFImVKHdtJF' }

      let(:subject) do
        WmOktaHelper::AuthenticateApiRequest.new(
          request: expected_request,
          okta_org: 'westernmilling',
          okta_domain: 'okta',
          okta_client_id: okta_client_id
        ).call
      end

      before do
        Timecop.freeze
      end

      after do
        Timecop.return
      end

      it 'returns nil' do
        expected_request # Trigger this before time travel
        Timecop.travel(Time.now.utc + 2.months)
        expect(subject).to be_nil
      end
    end
  end
end
