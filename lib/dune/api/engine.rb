module Dune
  module Api
    class Engine < ::Rails::Engine
      isolate_namespace Dune::Api

      config.to_prepare do
        ::User.send(:include, Dune::Api::UserConcern)
      end
    end
  end
end
