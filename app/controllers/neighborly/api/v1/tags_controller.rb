module Neighborly::Api
  module V1
    class TagsController < BaseController
      before_action :require_admin!

      has_scope :popular, type: :boolean
      has_scope :page,    default: 1

      def index
        collection = apply_scopes(Tag).all
        render json: collection, meta: {
          page:        collection.current_page,
          total:       Tag.count,
          total_pages: collection.total_pages
        }
      end

      def create
        respond_with Tag.create(permited_params)
      end

      def update
        respond_with Tag.update(params[:id], permited_params)
      end

      private

      def permited_params
        params.permit({ tag: [ :name, :visible ] })[:tag]
      end
    end
  end
end
