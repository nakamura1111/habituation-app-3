Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'targets#index'
  resources :targets, only: %i[index new create show] do
    resources :habits, only: %i[new create show] do
      member do
        put 'update_achieved_status'
      end
    end
    resources :small_targets, only: %i[new create show edit update]
  end
  # 再読み込みが発生した際の処理
  get '/users', to: 'users#retake_registration'
  get '/targets/:target_id/habits', to: 'habits#new'
  get '/targets/:target_id/small_targets', to: 'small_targets#new'
end
