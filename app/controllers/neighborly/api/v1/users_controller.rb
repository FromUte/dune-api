module Neighborly::Api
  module V1
    class UsersController < BaseController
      include PaginatedController

      before_action :require_admin!, only: :index
      has_scope :pg_search, as: :query

      def index
        respond_with_pagination collection
      end

      def show
        user = User.find(params[:id])
        render json: user, root: :user
      end

      private

      def collection
        @collection ||= begin
          apply_scopes(User).order('created_at desc').all
        end
      end
    end
  end
end
