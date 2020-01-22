# frozen_string_literal: true

class TestRequestExpired
  def initialize
    Rails.cache.write('OKTA_PUBLIC_KEYS', okta_key, expires_in: 3.months)
  end

  def okta_key
    { 'PRFzHQTc0IzGtoS3jQ-dRxJSXLevuU7vx0eagiBDazI' =>
      { 'kty' => 'RSA',
        'kid' => 'PRFzHQTc0IzGtoS3jQ-dRxJSXLevuU7vx0eagiBDazI',
        'use' => 'sig',
        'e' => 'AQAB',
        'n' => nonce } }
  end

  def nonce
    <<~NONCE.squish
      pjL-D9do5t1YY4i2Ll97HoEZAhwzwjNr8KHT05dtDRMfriY4Upn6b-14gxAzo1BKwnNU6Vc0beTNZW9PkBtuuRY7afwTl0LjUyw5fdDuA42NNsDDXc7UK2N-2AKi6me1zQIF-afy6ezBSjJIjXEDS2TBEOLebL0GGqDMKUhBk1ddLVUZnrUMLMUavwjo5_JHRn0_oqxImjWHYMrnVQh9uodhQYwxQpDbhx8vWayA89yJRFNm5C61PJXXUZMMcYWMAy5HyH5XOfxcOpCGhu5P5Av5K0jDikLSfHbG78YjiaiDyh9fACXGFhTVlwDLivrwlgYmjuj1tXd33P6GANfgmw
    NONCE
  end

  def id_token
    <<-TOKEN.squish
    eyJraWQiOiJQUkZ6SFFUYzBJekd0b1MzalEtZFJ4SlNYTGV2dVU3dngwZWFnaUJEYXpJIiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiIwMHUxYjM2NHlsVUlUbGFRMjJwNyIsIm5hbWUiOiJKb3NlIEZlcm5hbmRleiIsImVtYWlsIjoiamZlcm5hbmRlekB3ZXN0ZXJubWlsbGluZy5jb20iLCJ2ZXIiOjEsImlzcyI6Imh0dHBzOi8vd2VzdGVybm1pbGxpbmcub2t0YS5jb20iLCJhdWQiOiIwb2Ezc2cwcmVqb2F0SkVRNDJwNyIsImlhdCI6MTU3OTczMjgwMywiZXhwIjoxNTc5NzM2NDAzLCJqdGkiOiJJRC5Eek9OMUNyUjFsX21aWmZ6LVBhSHJHalRDeXh1WW83V0R0R3dycDVVVU1nIiwiYW1yIjpbInB3ZCJdLCJpZHAiOiIwMG9mdDAwZzNaZVVOZHh2WTJwNiIsIm5vbmNlIjoieldTZWgyR2k2b004ZXN1NnNGN0l2Q1Zmc3ZROFZpdVZMSlJJVWhYSEIxcUdGeDRmdU9jVk9kMXFjWjFiWlhOZyIsInByZWZlcnJlZF91c2VybmFtZSI6ImpmZXJuYW5kZXpAd2VzdGVybm1pbGxpbmcuY29tIiwiYXV0aF90aW1lIjoxNTc5NzMyODAzLCJhdF9oYXNoIjoiNXFVcEZlZmRoMGxCZFlXSHVDUFlvZyJ9.BjnHAIfDA_NEYvVzEpgn350GUY7g8HFNsCm_K39b_HQpxs7CQeVwwwHtT2WmZTNYoWyqrVfJvUdPGC0wtMNtH-qy0313gKa-XYD6Khg5Bxj1xlvGEEE487mFeWSNS_yC26PS5nS6pcVrLe41GXUsYp8_vZkvLqI_mdkfcjI8OTFjMtcPlFFoqs6rkOYyEa6OZ3UWJMtiSPcqdqc5ufzfn2uF6LapY8gjwVNszOb_Z53OLcClVnuHOJaSzuJA4dzkNvwNl6iZsATlC3uE8shkJSsApfF03SLXs1FBnae4SvPPU3hnOQLJOq4r55xaiK-Ur-ln6KtpViK6I7Rf399s0A
    TOKEN
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
