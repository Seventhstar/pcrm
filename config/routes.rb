Rails.application.routes.draw do
  get 'linked_works/create'

  get 'linked_works/destroy'

  get 'work/edit'

  get 'work/index'

  resources :costings
  get 'contacts/index'
  get 'contacts/new'

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

  resources :special_infos
  resources :comments do
    collection do
      post :read_comment
    end
  end

  resources :project_elongations
  get 'projects/:id/:action(. :format)' => 'projects#edit', constraint: { tab_id: '233' }
  resources :projects do
    resources :contacts
    collection do
      post :add_goodstype
    end
  end

  get 'projects/:id/:update_client' => 'projects#update_client'

  resources :project_goods
  resources :project_types
  resources :project_statuses
  resources :elongation_types
  resources :project_g_types
  resources :contact_kinds
  
  resources :clients

  resources :p_statuses
  resources :holidays

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
  get    'options/:options_page'  => 'options#edit', constraints: {format: /(json|html)/}
  post   'options/:options_page' => 'options#create'

  delete 'options/:options_page/:id' => 'options#destroy'
  delete 'options/:id' => 'options#destroy'

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


  #resources :leads
  resources :lead_sources
  resources :channels
  resources :statuses
  resources :wiki_cats

  resources :users
  resources :roles
  resources :user_roles
  resources :uoms
  resources :materials
  resources :consumptions
  resources :works
  resources :work_types
  resources :linked_works
  resources :work_linkers
 

  get "ajax/channels"
  get "ajax/leads"
  get "ajax/projects"

  post "ajax/read_comment"
  post "ajax/dev_check" 
  post "ajax/status_check" 
  post "ajax/switch_check" 
  post "ajax/switch_locked"
  post "ajax/upd_param"
  post "ajax/update_holidays"
  post "ajax/store_cut"

  resources :files
  get  '/download/:id'  => 'files#download'

  post "channels/new"

  get "/statistics/" => "statistics#show"
  get "/statistics/:page" => "statistics#show"

  get "/history/" => "history#show"
  get "/history/:period" => "history#show"

  root :to => "leads#index"
end
