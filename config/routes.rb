ActionController::Routing::Routes.draw do |map|
  map.resources :echoes, :collection => {:auth => :get, :begin_auth => :get, :forget_me => :delete}
  map.root :controller => "echoes"
end
