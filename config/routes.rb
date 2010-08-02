ActionController::Routing::Routes.draw do |map|
  map.namespace :admin, :collection => { :upload => :post } do |admin|
    admin.resources :styles
    admin.resources :scripts
  end
end