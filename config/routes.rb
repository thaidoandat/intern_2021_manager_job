Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    devise_for :accounts, controllers: {sessions: "sessions", registrations: "accounts"}


    resources :users, except: %i(index destroy)
    resources :companies, except: %i(index destroy)
    resources :user_apply_jobs, only: %i(new create)
    resources :account_activations, only: :edit
    resources :password_resets, except: %i(show index destroy)
    delete "/admin_logout", to: "admin_sessions#destroy"

    resources :admin, only: :index
    resources :admin_companies, only: :index
    resources :admin_sessions, only: %i(new create)
    resources :jobs
    resources :jobs do
      member do
        get "/apply_form", to: "user_apply_jobs#new", as: "apply_form"
      end
    end
    resources :companies do
      resources :jobs, only: %i(index show)
    end
    resources :user_apply_jobs, only: %i(show)
    resources :process_candidates, only: %i(update destroy)
  end
end
