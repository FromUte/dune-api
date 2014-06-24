module Neighborly::Api
  class BaseController < ActionController::Metal
    include AbstractController::Rendering
    include ActionController::ConditionalGet
    include ActionController::ForceSSL
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

    respond_to :json
  end
end
