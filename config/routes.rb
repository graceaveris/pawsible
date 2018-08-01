Rails.application.routes.draw do
  resources :users, only: [:create, :show, :update, :destroy]
  get "/leaderboard" => "users#leaderboard", as: "leaderboard"
  resources :uploads, only: [:index, :show]
  resources :challenges, only: [:index] do
    resources :uploads, only: [:create]
  end
  get "/search/autocomplete" => "uploads#autocomplete"

  # from clearance
  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]

  resources :users, controller: "users", only: [:create] do
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]
  end

  get "/sign_in" => "homepage#session_new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  # end
  
  root "homepage#index"
end
