Rails.application.routes.draw do
  
  # 顧客用
  devise_for :customers,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  
  scope module: :public do
    # homes
    root to: 'homes#top'
    get '/about' => 'homes#about', as: 'about'
    
    # customers
    get "customers/unsubscribe" => "customers#unsubscribe"
    patch "customers/withdraw" => "customers#withdraw"
    resources :customers, only: [:show, :edit, :update] do
      
      # relationships
      resource :relationships, only: [:create, :destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
    end
    
    # items
    resources :items do
      
      # favorites
      resource :favorites, only: [:create, :destroy]
      
      #item_comments
      resources :item_comments, only: [:create, :destroy]
    end
    
    # searches
    get "search" => "searches#search"
    
  end

  # 管理者用
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }
  
  namespace :admin do
    # customers
    resources :customers, only: [:index, :show, :edit, :update]
    
    # items
    resources :items, only: [:index, :show, :edit, :update]
    
    # searches
    get "search" => "searches#search"
    
  end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
