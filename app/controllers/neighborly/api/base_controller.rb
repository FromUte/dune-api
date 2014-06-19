module Neighborly::Api
  class BaseController < ActionController::Metal
    include ActionController::Redirecting
    include AbstractController::Rendering
    include ActionController::Renderers::All
    include ActionController::MimeResponds
    include ActionController::ConditionalGet
    include ActionController::ForceSSL
    include ActionController::Instrumentation

    #include ActionController::Helpers
    #include ActionController::UrlFor
    #include ActionController::RackDelegation
    #include AbstractController::Callbacks
    #include ActionController::Rescue

    include Neighborly::Api::Engine.routes.url_helpers
  end
end
