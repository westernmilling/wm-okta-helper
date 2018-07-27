# frozen_string_literal: true

RSpec.describe WmOktaHelper::PostRequest do
  describe '#call' do
    let(:response_headers) do
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
      let(:request_body) do
        ''
      end
      let(:url) do
        'https://westernmilling.okta.com/api/v1/authn'
      end

      let(:subject) do
        WmOktaHelper::PostRequest.new(
          request_body: request_body,
          url: url
        ).call
      end

      let(:response_body) do
        { 'expiresAt' => '2018-07-19T20:46:36.000Z',
          'status' => 'SUCCESS',
          'sessionToken' => 'a_long_token',
          '_embedded' =>
          { 'user' =>
            { 'id' => '00u1b364ylUITlaQ22p7',
              'profile' =>
              {
                'login' => 'jfernandez@westernmilling.com',
                'firstName' => 'Jose',
                'lastName' => 'Fernandez', 'locale' => 'en',
                'timeZone' => 'America/Los_Angeles'
              } } } }.to_json
      end

      it 'returns expected message hash' do
        stub_request(
          :post, 'https://westernmilling.okta.com/api/v1/authn'
        )
          .with(
            body: '""',
            headers: response_headers
          )
          .to_return(status: 200, body: response_body, headers: {})

        expect(subject['sessionToken']).to_not be_empty
      end
    end

    context 'with incorrect credentials' do
      let(:request_body) do
        ''
      end
      let(:url) do
        'https://westernmilling.okta.com/api/v1/authn'
      end

      let(:subject) do
        WmOktaHelper::PostRequest.new(
          request_body: request_body,
          url: url
        ).call
      end

      let(:response_body) do
        {
          'errors' => [{
            'title' => 'Not Authorized'
          }]
        }.to_json
      end

      it 'returns an error' do
        stub_request(
          :post, 'https://westernmilling.okta.com/api/v1/authn'
        )
          .with(
            body: '""',
            headers: response_headers
          )
          .to_return(status: 401, body: response_body, headers: {})

        errors = JSON.parse(response_body)['errors']
        expect(subject['sessionToken']).to be_nil
        expect(errors.first['title']).to eq 'Not Authorized'
      end
    end
  end
end
