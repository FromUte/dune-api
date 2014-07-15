module Neighborly::Api
  module V1
    class ChannelsController < BaseController
      def show
        respond_with Channel.find(params[:id])
      end
    end
  end
end
