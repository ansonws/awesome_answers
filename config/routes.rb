Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # This defines a 'route' rule that says when we recieve a 'GET' request with URL '/', handle it using the 'WelcomeController' with 'index' action inside that controller
  get("/", { to: 'welcome#index', as: 'root' } )

  get('/contacts/new', { to: 'contact#new' })

  post('/contacts', { to: 'contact#create' })

  get('/questions/new', { to: 'questions#new', as: :new_question})

  post('/questions', to: 'questions#create', as: :questions)

  get('/questions/:id', to: 'questions#show', as: :question)
  # question_path(<id>), question_url(<id>)
  get('/questions/:id/edit', to: 'questions#edit', as: :edit_question)
  # edit_question_path(<id>), edit_question_url(<id>)
  patch('/questions/:id', to: 'questions#update')
end
