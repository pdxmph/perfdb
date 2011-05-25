Perfdb::Application.routes.draw do
  resources :verticals
  resources :producers
  resources :general_managers
  resources :site_stats
  resources :site_data
  resources :site_datas
  resources :vertical_teams
  resources :authors
  resources :content_sources
  resources :content_types
  resources :views
  resources :articles
  resources :sites
  resources :editors

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action
  
  match 'reports/sixty_day_articles/', :controller => 'articles', :action => 'sixty_day_articles'
  match 'sites/:id/reports/overview/:year/:month', :controller  => 'sites', :action => 'show_month'
  match 'sites/:id/reports/authors/:year/:month', :controller => 'sites', :action => 'monthly_author_report'
  match 'sites/:id/reports/content/:year/:month', :controller => 'sites', :action => 'monthly_content'
  match '/models', :controller => 'sites', :action => 'perfdb_models'
  match '/', :controller => 'sites', :action => 'app_index'
  match 'sites/:id/reports/content', :controller => 'sites', :action => 'period_content'
  
  
  match 'sites/monthly_content_type_report/:id/:year/:month/', :controller  => 'sites', :action => 'monthly_content_type'
  match 'sites/monthly_content_source_report/:id/:year/:month/', :controller  => 'sites', :action => 'monthly_content_source'
  match 'content_types/:year/:month', :controller => 'content_types', :action => 'period_view'
  match 'site/:shortname/', :controller => 'sites', :action => 'show_site'
  match 'combined_content/', :controller => 'content_types', :action => 'combined_content'
  match 'combined_content/:year/:month', :controller => 'content_types', :action => 'combined_content_month_view'
  match 'articles/network_top_articles/:year/:month', :controller => 'articles', :action => 'network_top_articles'
  match 'vertical_teams/:id/:year/:month', :controller => 'vertical_teams', :action => 'show_month'
  match 'reports/:id/content_source', :controller => 'sites', :action => 'site_content_source'
  match 'reports/:id/content_type', :controller => 'sites', :action => 'site_content_type'
  match 'reports/content_source/:id/:year/:month', :controller => 'sites', :action => 'monthly_site_content_source'
  match 'reports/content_type/:id/:year/:month', :controller => 'sites', :action => 'monthly_site_content_type'
  match 'reports/network/content/:year/:month', :controller => 'content_types', :action => 'network_period_view'
  
  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
