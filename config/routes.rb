Dusoleil::Application.routes.draw do
  root :to => "hits#create"

  resources :hits, :only => [:index] do
    post 'ban', :on => :member
    get 'ban', :on => :member
  end
   get 'check_hit/:id', to: "hits#check_hit"
  resources :campaigns, :except => :edit do
    get 'campaign_clone', :on => :member
    get 'stats', :on => :member
    get 'hits', :on => :member
    get 'hit_counts', :on => :member
    get 'autocomplete', :on => :collection
    get 'referer_autocomplete', :on => :collection
  end
  
  resources :hit_counts, :only => [:index,:put] do
    put 'block', :on => :member
  end

  resources :hit_stats, :only => [:index]
  
  resource :sysconfigs, :only => [:show, :update], :path => "system" do
    post 'unban_me',    :on => :collection
    post 'reset_cache', :on => :collection
    put  'sync_data',   :on => :collection

    get 'search_ip',      :on => :collection
    post 'add_ban_ip',    :on => :collection
    post 'delete_ban_ip', :on => :collection
    post 'upload_ip_list',:on => :collection 

    get 'search_agent',      :on => :collection
    post 'add_ban_agent',    :on => :collection
    post 'delete_ban_agent', :on => :collection
    post 'upload_agent_list',:on => :collection 
  end

  resources :trackers, :except => :edit
end
