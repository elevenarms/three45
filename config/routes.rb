ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up ''
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

    map.connect '', :controller => 'dashboard',
                 :action => 'index'

  # Useful URLs
  map.register '/register', :controller => 'registrations', :action => 'new'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login  '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'

  map.resources :users, :member=>{ :reset_password=> :get, :change_password=> :post, :reset_password_on_behalf=> :get, :change_password_on_behalf=> :post }
  map.resource  :session

  # Create Referral tab
  map.resource :start_referral, :controller=>"StartReferral" do |start_referral|
    start_referral.resource :search, :controller=>'search'
  end

  # Request Referral tab
  map.resource :request_referral, :controller=>"RequestReferral" do |request_referral|
    request_referral.resource :search, :controller=>'search'
  end

  # Referral wizard
  map.resources :create_referral, :controller=>"CreateReferral",
                :member=> { :finish => :post } do |create_referral|
    create_referral.resource  :select_physician, :controller=>"SelectPhysician"
    create_referral.resources :faxes
    create_referral.resources :files
    create_referral.resources :insurance, :controller=>"Insurance", :collection=>{ :carrier_plan_options=>:get }
    create_referral.resource  :patient, :controller=>"Patient"
    create_referral.resource  :request, :controller=>"Request"
    create_referral.resources :studies
  end

  # Network tab
  map.resource  :network, :controller=>"Network" do |network|
    network.resources :profiles
    network.resources :tags
    network.resources :sponsors
    network.resources :friendships, :member=> { :block=> :post, :open=> :post }
    network.resource  :search, :controller=>'search'
  end

  # Referrals
  map.resources :referrals,
                :member=> { :summary => :get, :accept => :get, :decline => :get, :cancel => :get, :withdraw => :get, :new_info => :get, :all_info => :get, :select_consultant => :get, :change_consultant => :post, :close => :get, :reopen => :get } do |referrals|

    referrals.resources :messages,  :collection=> { :new_info => :get, :action_requested => :get, :new_file_attachment => :get, :new_fax_attachment => :get, :attach_file => :post, :attach_fax => :post }, :member=> { :new_reply => :get, :create_reply => :post, :print => :get }
  end

  # Fax/Fax Files
  map.resources :faxes, :member=> { :update_status => :post, :cover_page => :get} do |faxes|
    faxes.resources :fax_files, :member=>{ :download => :get }
  end

  map.resources :files, :member=> { :download => :get } do |files|
  end

  map.resources :profile_tags, :member=> {  } do |profile_tags|
  end

  # autocomplete
  map.suggest '/suggest', :controller => 'tags', :action => 'suggest'

  # Dashboard
  map.resources  :dashboard, :controller=> "Dashboard", :collection=>{ :quicklink=>:get }

  # Ad link mgmt/tracking
  map.resources  :ads

  # User Non Subscriber Landing Page
  map.resource :uns_welcome, :controller=>"UnsWelcome", :member => { }

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  #map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
