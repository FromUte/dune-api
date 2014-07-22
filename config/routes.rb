Neighborly::Api::Engine.routes.draw do
  scope module: :v1,
        constraints: Neighborly::Api::ApiConstraint.new(revision: 1, default: true),
        defaults: { format: :json } do

    resources :projects do
      member do
        put :approve
        put :launch
        put :reject
        put :push_to_draft
      end
    end

    resources :tags
    resources :contributions, only: %i(index)
    resources :users, only: %i(index show)

    get    'channels/:id', to: 'channels#show'
    post   'sessions',     to: 'sessions#create'
    delete 'sessions',     to: 'sessions#destroy'
  end
end
