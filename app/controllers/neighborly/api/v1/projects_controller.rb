module Neighborly::Api
  module V1
    class ProjectsController < Neighborly::Api::BaseController
      include PaginatedController

      has_scope :by_category_id, :order_by

      def index
        respond_with_pagination apply_scopes(scoped_by_state).all
      end

      private

      def scoped_by_state
        state_scopes = params.slice(*Project.state_names).keys
        if state_scopes.any?
          Project.with_state(state_scopes)
        else
          Project
        end
      end
    end
  end
end
