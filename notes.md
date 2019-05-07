gems install globally

Useful commands:
ruby -v
rvm -v
which ruby
gem list
gem install rails
gem install bundler
code ~/.railsrc 
~/.railsrc << -T -d postgresql --skip-turbolinks

Start project in parent folder of repo/project:
rails new "name_of_project"
This creates rails project

Set database names in testing in config/database.yml
Create database: "rails db:create" || "psql -d dbname"
Start server: "rails server" || "rails s"  || bin/rails s
When starting: Rails 5.2.3 application starting in development => mode of development

Environments: if no default given, rails assumes dev environment
* Dev
* Test
* Production

Gemfile: similar to package.json
Semantic versioning
Major - Minor - Patch
~> Only allows changes to last digit
Lock the gems on a particular version in gemfile.lock

update puma 

bundle => read Gemfile (e.g. puma ~> 3.11) => Patch gems => 
check system => if match update Gemfile else install in system

All gems are automatically 'required' for the Rails project so you can just use them anywhere without having to type require 'gem_name'

Add gems to Gemfile and then bundle
if no version specified, it will use version installed on system, if not installed then it will install the latest version
bundle will install any missing gems

rails c || rails console 

Router chooses controller, manages flow
View generates the html, css, js

rails g controller welcome || rails generate controller welcome
<!-- rails g scaffold "model" attr:data_type -->
rails d controller welcome || rails destroy controller welcome

```create  app/controllers/welcome_controller.rb
      invoke  erb
      create    app/views/welcome
      invoke  helper
      create    app/helpers/welcome_helper.rb
      invoke  assets
      invoke    coffee
      create      app/assets/javascripts/welcome.coffee
      invoke    scss
      create      app/assets/stylesheets/welcome.scss```

In config/application.rb in the class Application:
config.generators do |g|
    <!-- This will ignore helper and assets when generating welcome controller -->
    g.helper = false
    g.assets = false
end

In welcome_controller.rb, define index method. These are index actions.
Render templates in app/controllers/views/welcome
<%= render 'path_to_partial', obj: >

routes are in config/routes.rb
We keep the routes in seperate files
In express we keep route and 'controllers' together like this:
router.get("/", (req, res) => {})

In app/controllers/views/layouts, we get default layouts and our html is injected into <%= yield %>

use url for external links, path for locally

ActiveRecord is our ORM
Each ActiveRecord object has CRUD functionality and it allows us to interact with our database

Models are Ruby classes that we perform the logic with our database, sends it back to the controller. They inherit from ActiveRecord.

Model names singular. Controller names plural.

To generate a model run:
rails g model "model_name" table_column:datatype 
default datatype is string

To generate a model do rails g model <model-name> <...column-name:type...>
To run all your remaining migrations do: 
> rails db:migrate:status or rails db:migrate if schema doesn't exist
* Before you run db:migrate, you should inspect the file first*

Don't change the schema file. If you need to make a change, rollback by running:
> rails db:rollback(# of migrations to rollback)

Or even better, run a new migration:
rails g migration add_<migration-name e.g. "add_view_count_to_questions"> <column-name:datatype>
Delete column(s):
rails g migration remove_<migration-name e.g. "add_view_count_to_questions"> <column-name:datatype>

Our DB tables are classes, located in app/models
<table_class>.new instaniates
e.g. q = Question.new title: "Will this work?", body: "Seriously, will this work?"

q.persisted? => checks if object is in table/class
q.save => saves to the db and returns true
q.destroy

.create => creates and saves in one command
.all returns an ActiveRecord_Relation

A relation will only get executed if it's necessary

Query examples:
* Question.first / Question.last
* Question.first/second.third etc.
* Question.all.select { |q| q.title === "What are we doing?" }
* Question.select(:id, :title)
* Question.find(<id>)
* Question.find_by(title: "What are we doing?")
* Question.find_by_title("What are we doing?") # Metaprogramming, rails generates this method for us
    * find and find_by only returns the first record that matches the argument, returning an ActiveRecord_Object
* Question.where(title: "What are we doing?") # returns an ActiveRecord_Relation
    * Question.where(SQL QUERY) also works
    * Question.where "title ILIKE #{params[:title]}" # Beware of SQL injection
* Question.order "created_at DESC"
* q.update(title: "What aren't we doing?", body: "Help")
* q.destroy / q.delete # .destroy runs callbacks
* Question.count # SELECT COUNT(*) FROM "questions"

Add faker gem to Gemfile
> bundle
In db/seeds.rb, first you should delete:
Question.delete_all

Run seed
rails db:seed

Validations:
In question.rb file, create validation
e.g. validates(:title, presence: true)

Set downcase:
before_save { self.email = email.downcase }

.save will only work if validated
.valid?
.errors.full_message

Changing error messages

Create wireframes:
rails g controller --no-helper --no-assets
Make route. as: 'name'
View name in rails/info/routes, or /anyroutethatdoesn'texist
partials can use: f.submit @user.new_record? ? "Sign up" : "Update acount"

One to Many: 

rails g model answer body:text question:references 

rails g controller answers --skip-template-engine

new action is for displaying forms in questions
create action saves to the db

Authentication:
rails g model user first_name last_name email password_digest
Add email uniqueness, index and format to migration
rails db:migrate

install bcrypt and bundle
bcrypt hashes and salts password
salt is an additional string of data that adds to password

Add has_secure_password method to user model

rails g controller users
Create sign up form
New and create actions in users controller
Add resource :users in routes

rails g controller sessions
All we're really using this controller for is for signing in/out

rails g migration add_user_references_to_question user:references
rails g migration add_user_references_to_answer user:references

belongs_to gets put into model automatically when generated, but you'll have to add it yourself if you've already created it 

set @question.user and @answer.user

Authentication

It's generally better to compare objects rather than ids

Protect at the controller level and views level

rails g cancan:ability

user.id # undefined local variable or method 'user' 
defined?(user) && user.id # returns nil
user ||= User.new 

rails g migration add_is_admin_to_users is_admin:boolean
In migration file, make default: false

user.update is_admin: true

assets pipeline reduces http overhead buy not needed as many requests to be made

in app.js include libraries, and then own files afterwards
gem 'jquery-rails'

Heroku commands:
brew tap heroku/brew && brew install heroku
heroku create awesome-answers
git remote -v
git push heroku master
heroku run rails db:migrate db:seed
heroku log --tail
heroku run console
heroku restart

TESTING:

* Define tests by creating a .rb file with require "minitest/autorun"
* Create a class with a name that end in test, inheriting from MiniTest::Test
Get more info 

Add gem 'rspec-rails' to Gemfile group :dev :test 
bundle
rails g rspec:install
rails g model job_post title description:text min_salary:integer company_name
check migration file and migrate

rails db:drop db:create db:migrate db:seed

Use different port: rails s -p <port#>

Hide reviews stretch:
add_column :reviews, :hidden. :boolean, default: false

patch "/reviews/:id/toggle" => "reviews#toggle_hidden", as: "toggle_hidden"

To run test manually:
rspec sepc/models/job_post_spec.rb

RSpec with Rails controllers
To generate rspec for existing controller:
rails g rspec:controller <controller-name>

testdb gets reset with every test

rails c
FactoryBot.attributes_for :job_post
might need spring stop
FactoryBot.build
FactoryBot.create

rails g migration add_user_references_to_job_posts user:references

cancan review:
ability.rb file is used to define who can do what to which object

Delete vs. Destroy
HTTP verbs vs. CRUD Names

| HTTP VERBS | CRUD (Rails Controller Action Names) |
|------------|--------------------------------------|
| GET        | Read (Show, Index, New, Edit)        |
| POST       | Create (Create)                      |
| DELETE     | Delete (Destroy)                     |
| PATCH      | Update (Update)                      |
| PUT        | Update (Update)                      |
|---------------------------------------------------|

Steps to Setup Authentication

1. Create a User table (model) with a minimum of a `email` and `password_digest` columns.
2. Add `has_secure_password` to the User model.
3. Create a `UserController` to support creating users. This is for the  Sign Up page.
4. Create a `SessionController` to support the Sign In page and the Sign Out.
5. When a user Signs Up or Signs In, set their `user_id` in the `session` hash in `users#create` and `session#create`.
6. In `ApplicationController`, implement the `current_user` to get the user from the `user_id` in the `session`.
7. Implement the `authenticate_user!` method in the `ApplicationController`. This method is used with `before_action` in our controllters to prevent users that are not signed from accessing certain routes. 
For example:
`before_action :authenticate_user!, only: [:create]`
8. Use `before_action :authenticate_user!` where appropriate or where you need to restrict user access to your actions.

Lab: Test Drive New and Create with Users
rails g migration add_user_references_to_news_article user:references
rails db:migrate    
rails g factory_bot:model user

Many to many:
rails g model like user:references question:references
rails db:migrate

rails c
l = like.new(user: User.all.sample, question: Question.all.sample)
install gem 'hirb' in group :development
code ~/.pryrc

In user model has_many :likes, dependent: :destroy
has_many :liked_questions, through: :likes, source: :question

In question model has_many :likes, dependent: :destroy

u.liked_questions << Question.all.sample

Validation in Like model
validates :question_id, uniqueness: { scope: :user_id }

Go to show page to add like link
<%= link_to 'Like', question_likes_path(@question), method: :post %>
<%= pluralize(@question.likes.count, "like") %>

nest this route inside questions:
resources :likes, only: [:create, :destroy]

Generate likes controller
In create action, we don't need instance variables because we don't need to pass likes to views

To display like/unlike, go to question controller:
@like = @question.likes.find_by(user: current_user)
In show view: if @like.present?
in 'unlike, singular like in path, pass in @like as second argument

define destroy in likes controller

User.all.shuffle.slice(0, rand(User.count))

authenicate_user! in likes_controller
ability to like 
edit show page

Mailers
rails g mailer answer_mailer
This generates mailer, views for email body, and specs for testing 

ApplicationMailer < ActionMailer::Base

You can only send one file in an email, no external css and js files

mail(to: from: e.g.)
methods in Mailer class are class methods even though it looks like a regular method

rails c     
AnswerMailer.hello_world.deliver_now
AnswerMailer.new_answer(Answer.last).deliver_now


add gem 'letter_opener'

Open config/environments/development.rb

Add:
config.action_mailer.delivery_method = :letter_opener
config.action_mailer.perform_deliveries = true
config.action_mailer.default_url_options = {
    host: "localhost:3000"
}

set this to true:
config.action_mailer.raise_delivery_errors = false

Background jobs:
Add gems:
gem 'delayed_job_active_record'
gem 'delayed_job_web'
# Reduces boot times through caching; required in config/boot.rb

in config/application.rb:
config active_job queue_adapter = :delayed_job

To generate the migration for "delayed_job"'s queue, run:
rails g delayed_job:active_record

To generate a job file, run:
rails g job <job-name>

rails c
HelloWorldJob.perform_later
HelloWorldJob.set(wait: 10.seconds).perform_later
HelloWorldJob.set(wait: 10.years).perform_later

Open new terminal tab and generate worker:
rails jobs:work

Unlike mailers, you need a seperate class for each job

HTTP API

In questions controller:
respond_to do |format|
    format.html { render }
    format.json { render json: @question }
end

rails g controller api::v1::questions

In routes:
namespace :api, defaults: { format: :json } do
    namespace :v1 do
        resources :question 
    end
end

rails routes | grep api/v1

brew cask install postman

Add 'active_model_serializers' gem

Generate serializer:
rails g serializer question

  attributes(
    :id,
    :first_name,
    :last_name,
    :full_name
  )

  Custom methods also work because table columns are methods too

  Nested queries not included by default, so in api questions controller:
  include: [:author, {answers: [:author] }]

  Instead of self, use object to reference the instance that is being serialized

  We use :symbols for methods because of .send()

  Create a separate serializer just for index to avoid using the default question serializer and overfetching
  while rendering index:
  each_serializer: QuestionCollectionSerializer

  for new action, don't need to render json for form

  rails g controller api::application

  Add to api controller:
  skip_before_action(:verify_authenticity_token)

  rails g controller api::v1::sessions
  add resource for session in namespace v1

  In general, don't use redirects for apis
