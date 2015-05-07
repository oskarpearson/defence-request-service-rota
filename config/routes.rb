Rails.application.routes.draw do
  root "dashboards#show"

  resources :procurement_areas
  resources :procurement_area_locations, only: [:new, :create]
  resources :procurement_area_memberships, only: [:new, :create, :destroy]

  get "/dashboard", to: "dashboards#show", as: :dashboard
  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure", to: "sessions#failure"
end
