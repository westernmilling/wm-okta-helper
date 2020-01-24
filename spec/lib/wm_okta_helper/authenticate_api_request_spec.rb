# frozen_string_literal: true

require 'support/test_request'
require 'support/test_request_expired'

RSpec.describe WmOktaHelper::AuthenticateApiRequest do
  describe '#call' do
    let(:okta_client_id) { 'yEqoXVxrwxFImVKHdtJF' }
    let!(:expected_request) { TestRequest.new }

    let!(:validations_options) do
      {
        request: expected_request,
        okta_org: 'westernmilling',
        okta_domain: 'okta',
        okta_client_id: okta_client_id
      }
    end

    let!(:subject) do
      WmOktaHelper::AuthenticateApiRequest.new(validations_options).call
    end

    context 'with correct credentials' do
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
      let!(:okta_client_id) { 'wrong_key_here' }

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end

    context 'with missing credentials' do
      let(:subject) do
        WmOktaHelper::AuthenticateApiRequest.new(
          validations_options.merge(okta_client_id: '')
        ).call
      end

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end

    context 'with expired token' do
      let!(:expected_request) { TestRequestExpired.new }
      context 'with validations' do
        it 'returns nil' do
          Timecop.freeze do
            result = subject
            expect(result).to be_nil
          end
        end
      end

      context 'without validations' do
        let!(:okta_client_id) { '0oa3sg0rejoatJEQ42p7' }
        let!(:no_validations_options) do
          validations_options.merge(ignore_validations: true)
        end
        let!(:subject) do
          WmOktaHelper::AuthenticateApiRequest.new(no_validations_options).call
        end

        it 'returns expected message hash' do
          Timecop.freeze do
            result = subject
            expect(result).to have_key('iss')
            expect(result).to have_key('aud')
            expect(result['aud']).to eq okta_client_id
            expect(result['iss']).to eq 'https://westernmilling.okta.com'
            expect(subject['exp']).to_not be nil
          end
        end
      end
    end
  end
end
