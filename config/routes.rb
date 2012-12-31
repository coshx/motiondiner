MotionDiner::Application.routes.draw do
  devise_for :users

  resources :truck do
    member do
      put 'open'
      put 'close'
    end
  end

  resources :client do
    collection do
      get 'near_by_trucks'
    end
  end

  root :to => "home#index"
end
