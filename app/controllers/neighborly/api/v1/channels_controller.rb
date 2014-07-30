module Neighborly::Api
  module V1
    class ChannelsController < BaseController
      include PaginatedController
      has_scope :pg_search, as: :query

      def index
        respond_with_pagination collection
      end

      def show
        respond_with Channel.find(params[:id])
      end

      private

      def collection
        @collection ||= begin
          authorized_scope = policy_scope(Channel)
          apply_scopes(
            scoped_by_state(authorized_scope)
          ).order('created_at desc').all
        end
      end

      def scoped_by_state(scope)
        state_scopes = params.slice(*Channel.state_names).keys
        if state_scopes.any?
          scope.with_state(state_scopes)
        else
          scope
        end
      end
    end
  end
end
