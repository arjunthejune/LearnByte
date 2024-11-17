Rails.application.routes.draw do
  get "/decks/generator" => "decks#generator"
  resources :decks
  post "/decks/generate" => "decks#generate"

  resources :cards, only: [], param: :index do
    member do
      delete "(:id)" => "cards#destroy", as: ""
      post "/" => "cards#create"
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :decks do
    resources :cards
  end
end
