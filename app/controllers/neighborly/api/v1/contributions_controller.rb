module Neighborly::Api
  module V1
    class ContributionsController < BaseController
      include PaginatedController

      before_action :require_admin!

      has_scope :pg_search, as: :query
      has_scope :between_values,
        using: %i(initial final),
        type:  :hash

      def index
        respond_with_pagination collection
      end

      def show
        respond_with Neighborly::Api::Contribution.find(params[:id])
      end

      def update
        @contribution = ::Contribution.find(params[:id])
        authorize @contribution
        respond_with ::Contribution.update(params[:id], permitted_params)
      end

      [:confirm, :pendent, :refund, :hide, :cancel].each do |name|
        define_method name do
          contribution = ::Contribution.find(params[:id])
          authorize contribution

          contribution.send("#{name.to_s}!")
          head :no_content
        end
      end

      private

      def permitted_params
        params.permit(policy(@contribution || ::Contribution).permitted_attributes)[:contribution]
      end

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
