module Neighborly
  module Api
    class Engine < ::Rails::Engine
      isolate_namespace Neighborly::Api
    end
  end
end
