module Neighborly
  module Api
    module V1
      class UsersController < BaseController
        def show
          user = User.find(params[:id])
          render json: user, root: :user
        end
      end
    end
  end
end
