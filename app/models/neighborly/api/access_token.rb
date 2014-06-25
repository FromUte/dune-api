module Neighborly::Api
  class AccessToken < ActiveRecord::Base
    self.table_name = :api_access_tokens

    belongs_to :user

    before_create :generate_token

    protected

    def generate_token
      self.code = loop do
        random_token = SecureRandom.urlsafe_base64(50, false)
        break random_token unless self.class.exists?(code: random_token)
      end
    end
  end
end
