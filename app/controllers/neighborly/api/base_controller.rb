module Neighborly::Api
  class BaseController < ActionController::Metal
    include AbstractController::Rendering
    include ActionController::ConditionalGet
    include ActionController::ForceSSL
    include ActionController::HttpAuthentication::Token::ControllerMethods
    include ActionController::Instrumentation
    include ActionController::MimeResponds
    include ActionController::Redirecting
    include ActionController::Renderers::All
    include ActionController::Rendering

    #include ActionController::Helpers
    #include ActionController::UrlFor
    #include ActionController::RackDelegation
    #include AbstractController::Callbacks
    #include ActionController::Rescue

    include Neighborly::Api::Engine.routes.url_helpers

    before_action :check_authorization!

    respond_to :json

    def access_token
      @access_token
    end

    def current_user
      @current_user ||= access_token.user
    end

    def check_authorization!
      authenticate_or_request_with_http_token do |token, options|
        @access_token = AccessToken.find_by(code: token)
      end
      @access_token.is_a?(AccessToken) or handle_unauthorized
    end

    def handle_unauthorized
      head :unauthorized
    end
  end
end
