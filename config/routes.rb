Rails.application.routes.draw do
  
  resources :p_statuses

  resources :priorities

  resources :dev_projects
  resources :dev_statuses

  resources :goodstypes
  resources :budgets
  resources :styles
  resources :provider_managers

 
#  resources :budgets, only: [:edit, :update]
#  get 'budgets' => redirect('options/budgets'), only: [:index, :new, :create]

#  resources :styles, only: [:edit, :update]
#  get 'styles' => redirect('options/styles'), only: [:index, :new, :create]
#  get 'styles/new' => redirect('options/styles')

  resources :develops
  resources :providers

  get    'options'  => 'options#edit'
  get    'options/:options_page'  => 'options#edit'
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

  resources :leads_comments
  resources :channels
  resources :statuses

  resources :users

  root :to => "leads#index"
  

  get "ajax/channels"
  get "ajax/leads"

  post "ajax/add_comment"
  post "ajax/del_comment"
  post "ajax/dev_check" 
  post "ajax/user_upd" 
  post "ajax/status_check" 
  post "ajax/add_provider_manager" 
  post "ajax/del_provider_manager" 
  post "ajax/upd_param"

  post "file/del_file"
  post '/file' => 'file#create_file'
  get  '/download/:type/:id/:basename.:extension'  => 'file#download'

  post "channels/new"

  get "/pages/" => "pages#show"
  get "/pages/:page" => "pages#show"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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
