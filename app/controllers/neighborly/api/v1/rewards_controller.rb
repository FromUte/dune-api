module Neighborly::Api
  module V1
    class RewardsController < BaseController
      def show
        respond_with Reward.find(params[:id])
      end
    end
  end
end
