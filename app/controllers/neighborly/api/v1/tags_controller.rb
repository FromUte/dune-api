module Neighborly::Api
  module V1
    class TagsController < Neighborly::Api::BaseController
      before_action :require_admin!

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
