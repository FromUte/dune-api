module Dune::Api::UserConcern
  extend ActiveSupport::Concern

  included do
    has_many :access_tokens, class_name: 'Dune::Api::AccessToken'
  end

  def get_access_token
    (access_tokens.last || access_tokens.create).code
  end
end
