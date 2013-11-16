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

gem 'newrelic_rpm'
gem 'airbrake'
gem 'devise'
gem 'kaminari'
gem 'rails_config'
gem 'slim-rails'
gem 'simple_form'
gem 'paranoia', '~> 2.0.0'
gem 'rails_admin'
#gem 'xml-sitemap'

gem_group :development do
  gem 'pry-doc'
  gem 'pry-rails'
  gem 'quiet_assets'
  gem 'binding_of_caller'
  gem 'awesome_print'
end

gem_group :test do
  gem 'database_rewinder'
  gem 'shoulda-matchers'
  gem 'factory_girl_rails'
  gem 'faker'

  gem 'capybara'
  gem 'capybara-webkit'

  gem "simplecov", require: false
  gem 'simplecov-rcov', require: false

  gem 'rb-fsevent', require: false
  gem 'spork', '1.0.0rc3'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'guard-spork'
end

gem_group :development, :test do
  gem 'debugger'
  gem 'sqlite3'
  gem 'thin'
  gem 'rspec-rails'
  #gem 'timecop'
end

gem_group :production do
  gem 'pg'
  gem 'rails_12factor'
end

comment_lines 'Gemfile', "gem 'sqlite3'"

#
# Files and Directories
#

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

# .gitignore
remove_file '.gitignore'
get "#{repo_url}/gitignore", '.gitignore'

remove_file 'public/index.html'
remove_file 'app/assets/images/rails.png'

# bundler
get "#{repo_url}/bundle.config", '.bundle/config'

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
get "#{repo_url}/travis.yml", '.travis.yml'
run 'mv app/assets/stylesheets/application.css app/assets/stylesheets/application.css.scss'

# remove .keep
remove_file 'app/assets/images/.keep'
remove_file 'lib/tasks/.keep'

#
# Git
#
git :init
git add: '.'
git commit: '-am "Initial commit"'
