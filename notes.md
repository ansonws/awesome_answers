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

.save will only work if validated
.valid?
.errors.full_message

Changing error messages

Create wireframes:
rails g controller --no-helper --no-assets
Make route. as: 'name'
View name in rails/info/routes, or /anyroutethatdoesn'texist

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