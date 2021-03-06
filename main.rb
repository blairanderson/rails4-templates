#
# Application Template
#

repo_url = 'https://raw.github.com/blairanderson/rails4-templates/master'
gems = {}

@app_name = app_name

def get_and_gsub(source_path, local_path)
  get source_path, local_path
  gsub_file local_path, /%app_name%/, @app_name
end

#
# Gemfile
#

gem_group :production do
  gem 'pg'
  gem 'rails_12factor'
end

gem 'newrelic_rpm'
gem 'airbrake'
gem 'devise'
gem 'kaminari'
gem 'simple_form'
gem 'paranoia', '~> 2.0.0'
gem 'bootstrap-sass', github: 'thomas-mcdonald/bootstrap-sass', branch: '3'

gem_group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

gem_group :test do
  gem 'factory_girl_rails', '~> 4.0'
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'rb-fsevent'
  gem 'guard-rspec'
end

gem_group :development, :test do
  gem 'sqlite3'
  gem 'faker'
  gem 'thin'
  gem 'rspec-rails'
  gem 'pry-rails'
end

# use Rspec instead of TestUnit
remove_dir 'test'

application <<-APPEND_APPLICATION
config.generators do |g|
      g.test_framework      :rspec, fixture: true, view_specs: false
      g.integration_tool    :capybara
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end
    
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
APPEND_APPLICATION



# config/environments/development.rb
insert_into_file 'config/environments/development.rb',
                 %(    config.action_mailer.delivery_method = :file\n    config.action_mailer.default_url_options = Settings.action_mailer.default_url_options.to_hash\n),
                 after: "config.action_mailer.raise_delivery_errors = false\n"

# config/environments/test.rb
insert_into_file 'config/environments/test.rb',
                 %(    config.action_mailer.default_url_options = { host: 'example.com' }\n),
                 after: "config.action_mailer.delivery_method = :test\n"

# config/initializers
get "#{repo_url}/config/initializers/errbit.rb", 'config/initializers/errbit.rb'
get 'https://gist.github.com/rwdaigle/2253296/raw/newrelic.yml', 'config/newrelic.yml'

# .gitignore
remove_file '.gitignore'
get "#{repo_url}/gitignore", '.gitignore'

remove_file 'public/index.html'
remove_file 'app/assets/images/rails.png'

# helpers
remove_file 'app/helpers/application_helper.rb'
get "#{repo_url}/app/helpers/application_helper.rb", 'app/helpers/application_helper.rb'

# lib
get "#{repo_url}/lib/sitemap.rb", 'lib/sitemap.rb'

# rspec
get "#{repo_url}/rspec", '.rspec'
get "#{repo_url}/spec/factories.rb", 'spec/factories.rb'
get "#{repo_url}/spec/spec_helper.rb", 'spec/spec_helper.rb'
get "#{repo_url}/spec/support/controller_macros.rb", 'spec/support/controller_macros.rb'

# static files
remove_file 'public/favicon.ico'
get 'http://api.rubyonrails.org/favicon.ico', 'app/assets/images/favicon.ico'

remove_file 'app/assets/javascripts/application.js'
get "#{repo_url}/app/assets/javascripts/application.js", 'app/assets/javascripts/application.js'

remove_file 'app/assets/stylesheets/application.css'
get "#{repo_url}/app/assets/stylesheets/application.css.scss", 'app/assets/stylesheets/application.css.scss'
get "#{repo_url}/app/assets/stylesheets/mixins.css.scss", 'app/assets/stylesheets/mixins.css.scss'
get "#{repo_url}/app/assets/stylesheets/navbar.css.scss", 'app/assets/stylesheets/navbar.css.scss'
get "#{repo_url}/app/assets/stylesheets/navbar.css.scss", 'app/assets/stylesheets/navbar.css.scss'
get "#{repo_url}/app/assets/stylesheets/bootstrap_and_overrides.css.scss", 'app/assets/stylesheets/bootstrap_and_overrides.css.scss'


# remove .keep
remove_file 'app/assets/images/.keep'
remove_file 'lib/tasks/.keep'

#
# Git
#
git :init
git add: '.'
git commit: '-am "Initial commit"'
