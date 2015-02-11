module Dune::Api
  module V1
    class InvestmentsController < BaseController
      include PaginatedController

      before_action :require_admin!

      has_scope :pg_search, as: :query
      has_scope :by_project_id, as: :project_id
      has_scope :between_values,
        using: %i(initial final),
        type:  :hash

      def index
        respond_with_pagination collection
      end

      def show
        respond_with Dune::Api::Investment.find(params[:id])
      end

      def update
        @investment = ::Investment.find(params[:id])
        authorize @investment
        respond_with ::Investment.update(params[:id], permitted_params)
      end

      def destroy
        investment = ::Investment.find(params[:id])
        authorize investment

        investment.push_to_trash!
        head :no_content
      end

      [:confirm, :pendent, :refund, :hide, :cancel].each do |name|
        define_method name do
          investment = ::Investment.find(params[:id])
          authorize investment

          investment.send("#{name.to_s}!")
          head :no_content
        end
      end

      private

      def permitted_params
        params.permit(policy(@investment || ::Investment).permitted_attributes)[:investment]
      end

      def collection
        @collection ||= begin
          apply_scopes(
            scoped_by_state(Dune::Api::Investment)
          ).order('created_at desc').all
        end
      end

      def scoped_by_state(scope)
        state_scopes = params.slice(*Investment.state_names).keys
        if state_scopes.any?
          scope.with_state(state_scopes)
        else
          scope
        end
      end
    end
  end
end
