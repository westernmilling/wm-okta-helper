# frozen_string_literal: true

require 'okta_jwt_validation/version'

module OktaJwtValidation
  autoload :AuthenticateApiRequest,
           'okta_jwt_validation/authenticate_api_request.rb'
  autoload :CreateSession,
           'okta_jwt_validation/create_session.rb'
  autoload :ValidateSession,
           'okta_jwt_validation/validate_session.rb'
  autoload :PostRequest,
           'okta_jwt_validation/post_request.rb'
end
