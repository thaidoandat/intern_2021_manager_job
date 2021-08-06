Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    resources :accounts, only: %i(new create)
    resources :users, except: %i(index destroy)
    resources :companies, except: %i(index destroy)
    resources :user_apply_jobs, only: %i(new create)
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :jobs
    resources :jobs do
      member do
        get "/apply_form", to: "user_apply_jobs#new", as: "apply_form"
      end
    end
    resources :companies do
      resources :jobs, only: %i(index show)
    end
  end
end
