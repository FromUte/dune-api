module Neighborly::Api
  module V1
    class ProjectsController < Neighborly::Api::BaseController
      include PaginatedController

      has_scope :order_by
      has_scope :pg_search, as: :query
      has_scope :between_created_at,
        :between_expires_at,
        :between_online_date,
        using: %i(starts_at ends_at),
        type:  :hash

      def index
        respond_with_pagination collection
      end

      private

      def collection
        @collection ||= begin
          authorized_scope = policy_scope(Neighborly::Api::Project)
          apply_scopes(scoped_by_state(authorized_scope)).all
        end
      end

      def scoped_by_state(scope)
        state_scopes = params.slice(*Project.state_names).keys
        if state_scopes.any?
          scope.with_state(state_scopes)
        else
          scope
        end
      end
    end
  end
end
