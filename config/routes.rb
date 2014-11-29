PostitTemplate::Application.routes.draw do
  root to: 'posts#index'
  
  get   '/register',  to: 'users#new'
  get   '/login',     to: 'sessions#new'
  post  '/login',     to: 'sessions#create'
  get   '/logout',    to: 'sessions#destroy'
  get   '/connect',   to: 'sessions#connect'
  

  get '/auth/:provider/callback', to: 'sessions#create_with_auth'
  get '/auth/failure',            to: 'sessions#failure'

  resources :posts, except: [:destory] do
      member do
        post :vote
      end
  		resources :comments, only: [:create] do
        member do
          post :vote
        end
      end
  end

  resources :categories, only: [:new, :create, :show]

  resources :users, only: [:create, :edit, :show, :update]
end
