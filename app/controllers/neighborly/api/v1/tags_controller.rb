module Neighborly::Api
  module V1
    class TagsController < BaseController
      before_action :require_admin!

      include PaginatedController

      has_scope :popular, type: :boolean

      def index
        respond_with_pagination apply_scopes(Tag).all
      end

      def create
        respond_with Tag.create(permited_params)
      end

      private

      def permited_params
        params.permit({ tag: [ :name, :visible ] })[:tag]
      end
    end
  end
end
