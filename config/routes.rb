# frozen_string_literal: true

Rails.application.routes.draw do
  resources :authors do
    member do
      get 'books', to: 'authors#list_books'
      post 'add_book/:book_id', to: 'authors#add_book'
      delete 'remove_book/:book_id', to: 'authors#remove_book'
    end
  end
  resources :books

  get '/home', to: ->(_env) { [200, { 'Content-Type' => 'application/json' }, [{ message: 'Home Page!' }.to_json]] }

  devise_for :users, skip: %i[registrations sessions passwords],defaults: { format: :json }
  devise_scope :user do
    post '/signup', to: 'registrations#create'
    post '/login', to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy'
  end
end
