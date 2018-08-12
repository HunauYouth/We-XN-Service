Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'

  api vendor_string: 'api', default_version: 1 do
    version 1 do
      cache as: 'v1' do
        get 'bind-stu-user', to: 'bind_stu_user#index'
        get 'get-room', to: 'get_room#index'
        get 'wx-login', to: 'wx_login#index'
        get 'get-user-info', to: 'wx_login#get_user_info'
        resources :news, only: [:index, :show]
        resources :grade, only: [:index]
        resources :get_rooms, only: [:index]
        get 'get-room-list', to: 'get_rooms#get_room_list'
        resources :tran_items, only: [:index]
        get 'get_energy_query', to: 'get_energy#get_energy_query'
        get 'get_term', to: 'get_timetable#get_term'
        get 'get_timetable', to: 'get_timetable#get_timetable'
        get 'get_brows', to: 'get_brows#index'
        get 'today_brows', to: 'get_brows#today_brows'
        #get 'loss', to: 'get_brows#loss'
        get 'get_borrow', to: 'borrow_book#index'
        resources :feedback
        post 'bind-room', to: 'stu_user#bind_room'
        get 'hot-keys', to: 'book_retrieval#hot_keys'
        get 'book-search', to: 'book_retrieval#book_search'
        get 'book-detail', to: 'book_retrieval#book_detail'
        get 'book-collection', to: 'book_retrieval#lib_collection'
        get 'book-site', to: 'book_retrieval#lib_site'
        resources :notices, only: [:index]
        resources :officephone, only: [:index, :show]
        get 'faqs', to: 'faq#index'
        resources :lost_and_found
      end
    end
  end

end
