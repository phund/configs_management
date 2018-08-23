Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'

  resources :app_configs
  resources :reports
end
