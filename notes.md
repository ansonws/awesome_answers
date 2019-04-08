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
Start server: "rails server" || "rails s"  
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

