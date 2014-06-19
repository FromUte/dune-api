Neighborly::Api::Engine.routes.draw do
  scope module: :v1,
        constraints: Neighborly::Api::ApiConstraint.new(version: 1, default: true),
        defaults: { format: :json } do
    resources :projects
  end
end
