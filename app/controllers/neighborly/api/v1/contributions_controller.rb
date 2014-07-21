module Neighborly::Api
  module V1
    class ContributionsController < BaseController
      include PaginatedController

      has_scope :pg_search, as: :query
      has_scope :between_values,
        using: %i(initial final),
        type:  :hash

      def index
        respond_with_pagination collection
      end

      private

      def collection
        @collection ||= begin
          apply_scopes(
            scoped_by_state(Neighborly::Api::Contribution)
          ).order('created_at desc').all
        end
      end

      def scoped_by_state(scope)
        state_scopes = params.slice(*Contribution.state_names).keys
        if state_scopes.any?
          scope.with_state(state_scopes)
        else
          scope
        end
      end
    end
  end
end
