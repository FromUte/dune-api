module Neighborly::Api
  module V1
    class SessionsController < BaseController
      def create
        user = User.find_by(email: params.fetch(:email))
        if user.valid_password?(params.fetch(:password))
          render status: :created, json: {
            access_token: user.get_access_token,
            user_id:      user.id
          }
        else
          head :unauthorized
        end
      rescue KeyError
        head :bad_request
      end

      def destroy
        access_token = AccessToken.find_by(code: params.fetch(:access_token))
        if access_token
          access_token.expire!
          head :ok
        else
          head :bad_request
        end
      end
    end
  end
end
