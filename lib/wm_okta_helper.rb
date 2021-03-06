# frozen_string_literal: true

require 'wm_okta_helper/version'

module WmOktaHelper
  autoload :AuthenticateApiRequest,
           'wm_okta_helper/authenticate_api_request.rb'
  autoload :CreateSession,
           'wm_okta_helper/create_session.rb'
  autoload :GetUserGroups,
           'wm_okta_helper/get_user_groups.rb'
  autoload :PostRequest,
           'wm_okta_helper/post_request.rb'
  autoload :ValidateSession,
           'wm_okta_helper/validate_session.rb'
end
