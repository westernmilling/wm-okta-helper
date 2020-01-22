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
        'n' =>
        'pjL-D9do5t1YY4i2Ll97HoEZAhwzwjNr8KHT05dtDRMfriY4Upn6b-14gxAzo1BKwnNU6Vc0beTNZW9PkBtuuRY7afwTl0LjUyw5fdDuA42NNsDDXc7UK2N-2AKi6me1zQIF-afy6ezBSjJIjXEDS2TBEOLebL0GGqDMKUhBk1ddLVUZnrUMLMUavwjo5_JHRn0_oqxImjWHYMrnVQh9uodhQYwxQpDbhx8vWayA89yJRFNm5C61PJXXUZMMcYWMAy5HyH5XOfxcOpCGhu5P5Av5K0jDikLSfHbG78YjiaiDyh9fACXGFhTVlwDLivrwlgYmjuj1tXd33P6GANfgmw' } }
  end

  def id_token
    'eyJraWQiOiJWTkFUZ1ZoS0VaV2g5amdkNG1mazZoRFBBLXB3Sm9EZEFFZHcxdVMwRHZZIiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiIwMHV0ank2cnZUSTdYaUFiaDJwNiIsIm5hbWUiOiJTYW1hbnRoYSBUb3JyZXMiLCJlbWFpbCI6InN0b3JyZXNAd2VzdGVybm1pbGxpbmcuY29tIiwidmVyIjoxLCJpc3MiOiJodHRwczovL3dlc3Rlcm5taWxsaW5nLm9rdGEuY29tIiwiYXVkIjoiMG9hM3NnMHJlam9hdEpFUTQycDciLCJpYXQiOjE1NzEyNTg4MTIsImV4cCI6MTU3MTI2MjQxMiwianRpIjoiSUQuTGlyem90MklOQXF4RkhrczdBS29KYlY4T2lBa1d4TTdzTjBhamtiOWZXYyIsImFtciI6WyJwd2QiXSwiaWRwIjoiMDBvZnQwMGczWmVVTmR4dlkycDYiLCJub25jZSI6IkJuTDZ0WmxSZDNRaGRaWlBPUndxVUxPUDJqUW5zSTk0RnpUZ3E1UENGY3dqMldmRWJjcE5OcEhNWEZOeUxYN0UiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJzdG9ycmVzQHdlc3Rlcm5taWxsaW5nLmNvbSIsImF1dGhfdGltZSI6MTU3MTI1ODgxMiwiYXRfaGFzaCI6IkgxcEUwaFNlUEhEYVpqN0ZMZ09pMUEifQ.hStHlFWodLZdwucUumKldtA6ILuu3Rzm8joGgEnD7_UHyO9ftlFVKgdG7GVtCiN0PAjXw6CNRI3wRQ8wfDTVrzhwOjD3VRf1FCaryx0wcEgsE9RPFc5zeeIJnVWZ6lXaMWRhbe_JSmluoT5CTDWQR1gau_jdR8I3tffwtizjFDKVAjEtaMgXISDc_yj8YCpKaRprluv0k_6khSBlcJ2ROOI_irOiojNHSJ-xyFqEnya5p3SRrRNP2Uc1--k_dgZJ0UmJINtWDa387kYuqdaqLIpQ9bogyLXjcQTdFXlx4brzVZHQqGkW8MKjciw1KBt6Q_rQGAExfov-uyuRYtRUlg'
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
