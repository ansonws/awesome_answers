Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # This defines a 'route' rule that says when we recieve a 'GET' request with URL '/', hadle it using the 'WelcomeController' with 'index' action inside that controller
  get("/", { to: 'welcome#index', as: 'root'} )

  get('/contacts/new', {to: 'contact#new'})

  post('/contacts', { to: 'contact#create' })
end
