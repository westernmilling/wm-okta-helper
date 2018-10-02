# frozen_string_literal: true

require 'pry'

RSpec.describe WmOktaHelper::CreateSession do
  describe '#call' do
    let(:subject) do
      WmOktaHelper::CreateSession.new(
        username: username,
        password: 'pwd',
        okta_org: 'westernmilling',
        okta_domain: 'okta'
      ).call
    end

    let(:response) do
      f = File.join(%W[./ spec support fixtures #{fixture_file}])
      JSON.parse(File.read(f))
    end

    before do
      allow_any_instance_of(WmOktaHelper::PostRequest).to receive(:call)
        .and_return(response)
    end

    context 'with correct credentials' do
      let(:username) { 'Test User' }
      let(:fixture_file) { 'create_session_success.json' }

      it 'returns expected message hash' do
        expect(subject).to have_key('sessionToken')
      end
    end

    context 'with incorrect credentials' do
      let(:username) { 'Test User' }
      let(:fixture_file) { 'create_session_failure.json' }

      it 'returns expected error hash' do
        expect { subject }.to raise_error(RuntimeError, 'Not authorized')
      end
    end

    context 'with incorrect credentials' do
      let(:username) { nil }
      let(:fixture_file) { 'create_session_failure.json' }

      it 'returns expected error hash' do
        expect { subject }.to raise_error(
          RuntimeError,
          'Missing configuration variable: [:username]'
        )
      end
    end
  end
end
