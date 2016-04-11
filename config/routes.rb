Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  
  namespace :admin do
    resource :experiences_drop_ship_settings
    resources :experiences
  end
end
