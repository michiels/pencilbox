Pencilbox::Application.routes.draw do

  devise_for :users, controllers: { registrations: "users/registrations" }
  def boxes_host
    if Rails.env.production?
      "pencilbox.es"
    else
      "pencilboxes.dev"
    end
  end

  def root_host
    if Rails.env.production?
      "thisispencilbox.com"
    else
      "thisispencilbox.dev"
    end
  end

  constraints host: /^pencilboxes.dev|pencilbox.es/ do
    root to: redirect(host: root_host), defaults: { host: root_host }
    resources :boxes, :path => "", :defaults => { host: boxes_host } do
      member do
        get "images/*filename" => "images#show"
      end
    end
  end

  constraints host: /^thisispencilbox.com|thisispencilbox.dev/ do
    get "dropbox/authorize" => "dropbox#authorize", :as => :link_dropbox
  end

  root to: "frontpage#index", defaults: { host: root_host }

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root to: 'welcome#index'

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

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
