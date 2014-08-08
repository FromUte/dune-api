module Neighborly::Api
  module V1
    class ChannelsController < BaseController
      include PaginatedController
      before_action :require_admin!, except: %i(index show)

      has_scope :pg_search, as: :query

      def index
        respond_with_pagination collection
      end

      def show
        respond_with Channel.find(params[:id])
      end

      def destroy
        channel = Channel.find(params[:id])
        authorize channel

        channel.delete
        head :no_content
      end

      [:push_to_draft, :push_to_online].each do |name|
        define_method name do
          channel = Channel.find(params[:id])
          authorize channel

          channel.send("#{name.to_s}!")
          head :no_content
        end
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
