# frozen_string_literal: true

RSpec.describe Okta::Jwt::Validation do
  it 'has a version number' do
    expect(Okta::Jwt::Validation::VERSION).not_to be nil
  end
end
