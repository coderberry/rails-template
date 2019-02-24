apply "config/application.rb"
template "config/database.example.yml.tt"
remove_file "config/database.yml"
copy_file "config/puma.rb", force: true
remove_file "config/secrets.yml"
copy_file "config/sidekiq.yml"

gsub_file "config/routes.rb", /  # root 'welcome#index'/ do
  '  root "pages#index"'
end

copy_file "config/initializers/date_formats.rb"
copy_file "config/initializers/enums.rb"
copy_file "config/initializers/generators.rb"
copy_file "config/initializers/pagy.rb"
copy_file "config/initializers/rotate_log.rb"
copy_file "config/initializers/secret_token.rb"
template "config/initializers/sidekiq.rb.tt"
copy_file "config/initializers/simple_form_bootstrap.rb"
copy_file "config/initializers/simple_form.rb"
copy_file "config/initializers/version.rb"

gsub_file "config/initializers/filter_parameter_logging.rb", /\[:password\]/ do
  "%w[password secret session cookie csrf]"
end

apply "config/environments/development.rb"
apply "config/environments/production.rb"
apply "config/environments/test.rb"
template "config/environments/staging.rb.tt"

copy_file "config/webpack/extensions.rb", force: true
copy_file "config/webpack/loaders/erb.js"

route 'root "pages#index"'
route %Q(mount Sidekiq::Web => "/sidekiq" # monitoring console\n)
