angular = yes?("Install angular?")

def source_paths
  [File.join(File.expand_path(File.dirname(__FILE__)),'templates')] + Array(super)
end

# GEMS

# let your Gemfile do the configuring
gem 'haml-rails', '~> 0.9'

gem_group :development, :test do
  # testing with rspec
  gem 'rspec-rails'

  # Guard is a command line tool to easily handle events on file system modifications.
  gem 'guard', require: false

  # Guard gem for RSpec
  gem 'guard-rspec'

  # factory_girl_rails provides integration between factory_girl and rails 3
  gem 'factory_girl_rails'

  # Easily generate fake data
  gem 'faker'

  # Strategies for cleaning databases.
  gem 'database_cleaner'



  # Preview mail in browser instead of sending.
  gem 'letter_opener'

  # A gem providing "time travel", "time freezing", and "time acceleration"
  # capabilities, making it simple to test time-dependent code.
  # It provides a unified method to mock Time.now, Date.today,
  # and DateTime.now in a single call.
  gem 'timecop'
end


if angular
  log 'adding angular gems'

  # Angular.
  gem 'angularjs-rails'
  # Summary: Use ngannotate in the Rails asset pipeline.
  gem 'ngannotate-rails'
  # This adds ui-routes for improved routes
  gem 'angular-ui-router-rails', git: 'https://github.com/iven/angular-ui-router-rails.git'


  log 'inserting angular files'

  log "Inseting requre angular files and tags to application.js and applicaiton.html"
  insert_into_file 'app/assets/javascripts/application.js', before: "//= require_tree" do
"//= require angular
//= require angular-animate
//= require angular-resource
//= require angular-ui-router
//= require angular/config\n"
  end

  log "removing turbolinks"
  gsub_file "Gemfile", /^gem\s+["']turbolinks["'].*$/,''
  log "removing turbolinks from aplication.js"
  gsub_file "app/assets/javascripts/application.js", /\/\/= require turbolinks\n/,''
  gsub_file "app/views/layouts/application.html.erb", /, 'data-turbolinks-track' => true/, ''

  log "add ng-view and remove erb yield"
  insert_into_file 'app/views/layouts/application.html.erb', "<ng-view></ng-view>", after: "<body>\n"
  gsub_file "app/views/layouts/application.html.erb", /, '<%= yield %>/, ''

  log "Insert support for ui-routes"
  insert_into_file 'app/views/layouts/application.html.erb', "<div ui-view></div>", before: "\n</body>"

  log "Create AngularJS directories and config file"
  inside 'app/assets/javascripts/angular' do
    template 'config.coffee'

    inside 'controllers' do

    end
    inside 'factories' do

    end
    inside 'routes' do
      template 'routes.coffee'
    end
    inside 'services' do

    end
  end

end


environment 'config.action_mailer.default_url_options = {host: "localhost:3000"}', env: 'development'
environment 'config.action_mailer.delivery_method = :letter_opener', env: 'development'

log "Remove test folder and add generator defaults"
insert_into_file 'config/application.rb', after: "# config.i18n.default_locale = :de\n" do
  "  config.generators do |g|
    g.stylesheets false
    g.test_framework :rspec
    g.fixture_replacement :factory_girl
  end\n"
end
run 'rm -r test/'

log "Create default controller"
inside 'app/controllers' do
  template 'layouts_controller.rb'
end

log "Add default route to routes.rb"
route "root to: 'layouts#index'"


after_bundle do
  log 'setting up rspec'
  run "spring stop"
  run "rails generate rspec:install"
  run "rails generate haml:application_layout convert"
  run "spring start"

  File.delete("./app/views/layouts/application.html.erb")

  log "Setting up git"
  git :init
  git add: "-A"
  git commit: %Q{ -m 'Initial commit' }
end
