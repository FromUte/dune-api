module Neighborly::Api
  module V1
    class TagsController < Neighborly::Api::BaseController
      before_action :require_admin!

      def create
        tag = Tag.new(permited_params)

        if tag.save
          render json: tag, status: :created
        else
          respond_with tag
        end
      end

      private

      def permited_params
        params.permit({ tag: [ :name, :visible ] })[:tag]
      end
    end
  end
end
