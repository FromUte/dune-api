module Dune::Api
  class BaseController < ActionController::Metal

  MODULES = [
      AbstractController::Rendering,
      ActionController::Redirecting,
      ActionView::Rendering, # This is needed because of respond_with
      ActionController::Rendering,
      ActionController::Renderers::All,
      ActionController::ConditionalGet,
      ActionController::MimeResponds,
      ActionController::ImplicitRender,
      ActionController::StrongParameters,
      ActionController::ForceSSL,
      ActionController::HttpAuthentication::Token::ControllerMethods,
      ActionController::Serialization,
      ActionController::Instrumentation,
      ActionController::ParamsWrapper,
      ActionController::Rescue,
      HasScope,
      Pundit,
      Dune::Api::Engine.routes.url_helpers,
      Rails.application.routes.url_helpers,
      Pundit,

      #ActionController::Helpers,
      #ActionController::UrlFor,
      #ActionController::RackDelegation,
      #AbstractController::Callbacks,
    ]

    MODULES.each do |mod|
      include mod
    end

    respond_to :json
    before_action :check_authorization!

    rescue_from Pundit::NotAuthorizedError,  with: :handle_forbidden

    def handle_forbidden
      head :forbidden
    end

    def access_token
      @access_token
    end

    def current_user
      @current_user ||= access_token.user
    end

    def require_admin!
      handle_unauthorized unless current_user.admin?
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
