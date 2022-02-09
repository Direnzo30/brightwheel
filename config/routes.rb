Rails.application.routes.draw do
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :readings, param: :device_id, only: [] do
        collection do
          post 'record', to: 'readings#record'
        end
        member do
          get 'most_recent', to: 'readings#most_recent'
          get 'total_count', to: 'readings#total_count'
        end
      end
    end
  end
end
