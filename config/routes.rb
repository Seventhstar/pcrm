Rails.application.routes.draw do
  
  resources :payments

  get 'project_status/name'

  resources :absence_reasons
  resources :absence_targets
  resources :absence_shops
  resources :absence_shop_targets
  resources :absences

  resources :wiki_records do
    resources :wiki_records
  end
  resources :wiki_files

  resources :payment_purposes
  resources :payment_types

  resources :receipts do
    collection do
      get :to_move
      put :to_update
    end
  end

  resources :receipts

  resources :projects
  resources :project_types
  resources :project_statuses
  resources :clients

  resources :p_statuses

  resources :priorities

  resources :dev_projects
  resources :dev_statuses

  resources :goodstypes
  resources :budgets
  resources :styles
  resources :provider_managers
 
  resources :develops
  resources :providers

  get    'options'  => 'options#edit'
  get    'options/:options_page'  => 'options#edit',:constraints => {:format => /(json|html)/}

  delete 'options/:options_page/:id' => 'options#destroy'

  get    'signup'  => 'users#new'
  get    'login'   => 'sessions#new'                                   
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]

#  get '/leads/update_multiple/', to: 'leads#edit_multiple'
  resources :leads do
    collection do
      get :edit_multiple
      put :update_multiple
    end
  end

  resources :leads

#  resources :leads_comments
  resources :channels
  resources :statuses

  resources :users

  root :to => "leads#index"
  

  get "ajax/channels"
  get "ajax/leads"

  post "ajax/add_comment"
  post "ajax/del_comment"
  post "ajax/dev_check" 
  post "ajax/status_check" 
  post "ajax/switch_check" 
  post "ajax/upd_param"

  post "file/del_file"
  post '/file' => 'file#create_file'
  get  '/download/:type/:id/:basename.:extension'  => 'file#download'

  post "channels/new"

  get "/statistics/" => "statistics#show"
  get "/statistics/:page" => "statistics#show"

  get "/history/" => "history#show"
  get "/history/:period" => "history#show"


  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
