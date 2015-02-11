module Dune::Api
  module V1
    class SessionsController < BaseController
      skip_before_action :check_authorization!, only: :create

      def create
        user = User.find_by(email: params.fetch(:email))
        if user && user.valid_password?(params.fetch(:password))
          render status: :created, json: {
            access_token: user.get_access_token,
            user_id:      user.id
          }
        else
          render status: :unauthorized, json: {}
        end
      rescue KeyError
        render status: :bad_request, json: {}
      end

      def destroy
        access_token.try(:expire!)

        render status: :ok, json: {}
      end
    end
  end
end
