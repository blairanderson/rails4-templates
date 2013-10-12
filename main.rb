#
# Application Template
#

repo_url = 'https://raw.github.com/mtfuji/rails4-templates/master'
gems = {}

@app_name = app_name

def get_and_gsub(source_path, local_path)
  get source_path, local_path
  gsub_file local_path, /%app_name%/, @app_name
end

#
# Gemfile
#

gem 'airbrake'
gem 'devise', github: 'plataformatec/devise'
gem 'kaminari'
gem 'rails_config'
gem 'slim-rails'
gem 'bootstrap-sass', branch: '3'
gem 'simple_form'
gem 'paranoia', '~> 2.0.0'
gem 'rails_admin'
#gem 'xml-sitemap'

gem_group :development do
  gem 'capistrano_colors'
  gem 'capistrano-ext'
  gem 'capistrano-rbenv'

  gem 'meta_request'
  #gem 'pry-doc'
  gem 'pry-rails'
  gem 'tapp'
  gem 'quiet_assets'
end

gem_group :test do
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'factory_girl_rails'
  gem 'cucumber-rails', require: false
  #gem 'faker'

  gem 'capybara'
  gem 'capybara-webkit'
  gem 'selenium-webdriver'

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
  gem 'zeus'
  gem 'sqlite3'
  gem 'thin'
  gem 'rspec-rails'
  #gem 'timecop'
end

gem_group :production do
  gem 'mysql2'
end

comment_lines 'Gemfile', "gem 'sqlite3'"
comment_lines 'Gemfile', "gem 'turbolinks'"
uncomment_lines 'Gemfile', "gem 'therubyracer'"

#
# Files and Directories
#

# use Rspec instead of TestUnit
remove_dir 'test'

application <<-APPEND_APPLICATION
config.generators do |g|
      g.test_framework      :rspec, fixture: true, view_specs: false
      g.integration_tool    :cucumber
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

# capistrano
get "#{repo_url}/Capfile", 'Capfile'

# views
remove_file 'app/views/layouts/application.html.erb'
get_and_gsub "#{repo_url}/app/views/layouts/application.html.slim", 'app/views/layouts/application.html.slim'
%w(first_page gap last_page next_page page paginator prev_page).each do |key|
  get "https://raw.github.com/Ushiromia/bootstrap-kaminari-slim/master/app/views/kaminari/_#{key}.html.slim", "app/views/kaminari/_#{key}.html.slim"
end

# helpers
remove_file 'app/helpers/application_helper.rb'
get "#{repo_url}/app/helpers/application_helper.rb", 'app/helpers/application_helper.rb'

# config/deploy
get "#{repo_url}/config/deploy/production.rb", 'config/deploy/production.rb'

# config/locales/ja.yml
get 'https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/ja.yml', 'config/locales/ja.yml'
get 'https://gist.github.com/raw/3104030/d3cd6bf55bc905b89b6e08d9454a48c92b81bfdc/devise.ja.yml', 'config/locales/devise.ja.yml'
get 'https://gist.github.com/mshibuya/1662352/raw/a5ce6fb646d53ca44434a8b7ab238aeeb8791d27/rails_admin.ja.yml', 'config/rails_admin.ja.yml'
get "#{repo_url}/config/locales/helpers.ja.yml", 'config/locales/helpers.ja.yml'

# config/database.yml
gsub_file 'config/database.yml', /^test:$/, 'test: &test'
insert_into_file 'config/database.yml',
                 %(cucumber:\n  <<: *test\n\n),
                 before: 'production:'
run 'cp config/database.yml config/database.example.yml'
#get "#{repo_url}/config/database.yml", 'config/database.yml'

# config/deploy.rb
get_and_gsub "#{repo_url}/config/deploy.rb", 'config/deploy.rb'

# config/application.rb
insert_into_file 'config/application.rb',
                 %(    config.time_zone = 'Tokyo'\n),
                 after: "# config.time_zone = 'Central Time (US & Canada)'\n"

insert_into_file 'config/application.rb',
                 %(    config.i18n.default_locale = :ja\n),
                 after: "# config.i18n.default_locale = :de\n"

# config/environments/development.rb
insert_into_file 'config/environments/development.rb',
                 %(    config.action_mailer.delivery_method = :file\n    config.action_mailer.default_url_options = Settings.action_mailer.default_url_options.to_hash\n),
                 after: "config.action_mailer.raise_delivery_errors = false\n"

# config/environments/test.rb
insert_into_file 'config/environments/test.rb',
                 %(    config.action_mailer.default_url_options = { host: 'example.com' }\n),
                 after: "config.action_mailer.delivery_method = :test\n"

# config/settings
run 'touch config/settings.yml'
get "#{repo_url}/config/settings/development.yml", 'config/settings/development.yml'
get "#{repo_url}/config/settings/test.yml", 'config/settings/test.yml'
get_and_gsub "#{repo_url}/config/settings/production.yml", 'config/settings/production.yml'

# config/initializers
get "#{repo_url}/config/initializers/errbit.rb", 'config/initializers/errbit.rb'

# lib
get "#{repo_url}/lib/sitemap.rb", 'lib/sitemap.rb'

# lib/tasks
get "#{repo_url}/lib/tasks/extract_fixtures.rake", 'lib/tasks/extract_fixtures.rake'

# lib/templates
get "#{repo_url}/lib/templates/slim/scaffold/_form.html.slim", 'lib/templates/slim/scaffold/_form.html.slim'
get "#{repo_url}/lib/templates/slim/scaffold/index.html.slim", 'lib/templates/slim/scaffold/index.html.slim'
get "#{repo_url}/lib/templates/slim/scaffold/edit.html.slim", 'lib/templates/slim/scaffold/edit.html.slim'
get "#{repo_url}/lib/templates/slim/scaffold/new.html.slim", 'lib/templates/slim/scaffold/new.html.slim'
get "#{repo_url}/lib/templates/slim/scaffold/show.html.slim", 'lib/templates/slim/scaffold/show.html.slim'
get "#{repo_url}/lib/templates/rails/scaffold_controller/controller.rb", 'lib/templates/rails/scaffold_controller/controller.rb'

# rspec
get "#{repo_url}/rspec", '.rspec'
get "#{repo_url}/spec/factories.rb", 'spec/factories.rb'
get "#{repo_url}/spec/spec_helper.rb", 'spec/spec_helper.rb'
get "#{repo_url}/spec/support/controller_macros.rb", 'spec/support/controller_macros.rb'

# static files
remove_file 'public/favicon.ico'
get 'http://api.rubyonrails.org/favicon.ico', 'app/assets/images/favicon.ico'
get "#{repo_url}/travis.yml", '.travis.yml'
get 'http://newrelic.com/assets/pages/application_monitoring/logos/lang_ruby.png', 'app/assets/images/apple-touch-icon-144x144-precomposed.png'
get 'https://fbexternal-a.akamaihd.net/safe_image.php?d=AQDXiqes17_vjH3T&w=155&h=114&url=http%3A%2F%2Fcdn.tutsplus.com%2Fnet.tutsplus.com%2Fauthors%2Fjeffreyway%2Frails-history-preview-image.png', 'app/assets/images/apple-touch-icon-114x114-precomposed.png'
get 'http://4.bp.blogspot.com/-S5WVH9zVULA/UMHpxhJuZkI/AAAAAAAAAa4/w6LeyOLDfio/s72-c/150px-Ruby_on_Rails.svg.png', 'app/assets/images/apple-touch-icon-72x72-precomposed.png'
get 'http://www.usahostingservices.com/pics/1-rubyonrails.PNG', 'app/assets/images/apple-touch-icon-precomposed.png'
gsub_file 'app/assets/javascripts/application.js', /turbolinks/, 'bootstrap'
append_to_file 'app/assets/stylesheets/application.css', '@import "bootstrap";'
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
