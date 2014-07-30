module Neighborly::Api
  module V1
    class PressAssetsController < BaseController
      before_action :require_admin!, except: %i(index show)

      include PaginatedController

      def index
        respond_with_pagination apply_scopes(PressAsset).all
      end

      def create
        respond_with PressAsset.create(permited_params)
      end

      def update
        respond_with PressAsset.update(params[:id], permited_params)
      end

      def show
        respond_with PressAsset.find(params[:id])
      end

      def destroy
        respond_with PressAsset.destroy(params[:id])
      end

      private

      def permited_params
        params.permit(
          { press_asset:
            PressAsset.attribute_names.map(&:to_sym) - [:created_at, :updated_at]
        })[:press_asset]
      end
    end
  end
end
