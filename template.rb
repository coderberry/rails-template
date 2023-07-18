require "fileutils"
require "shellwords"

def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require 'tmpdir'
    source_paths.unshift(tempdir = Dir.mktmpdir('rails-'))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      '--quiet',
      'https://github.com/coderberry/rails-template.git',
      tempdir
    ].map(&:shellescape).join(' ')
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

def set_application_name
  # Add Application Name to Config
  environment 'config.application_name = Rails.application.class.module_parent_name'

  # Announce the user where they can change the application name in the future.
  puts 'You can change application name inside: ./config/application.rb'
end

def add_gems
  gem "arel-helpers"
  gem "bullet"
  gem "devise"
  gem "friendly_id"
  gem "name_of_person"
  gem "sidekiq"
  gem "turbo_boost-commands"
  gem "turbo_boost-streams"
  gem "vite_rails"
  gem "whoop"

  gem_group :development do
    gem "annotate"
    gem "magic_frozen_string_literal"
    gem "codecov"
    gem "model_probe"
    gem "organize_gemfile"
    gem "simplecov"
    gem "sord"
    gem "standard"
  end

  gem_group :development, :test do
    gem "factory_bot_rails"
    gem "rspec-rails"
  end
end

def add_users
  # Install Devise
  generate "devise:install"

  # Configure Devise
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }\n",
              env: 'development'

  # Create Devise User
  generate :devise, "User", "first_name", "last_name", "slug:uniq", "admin:boolean"

  # set admin boolean to false by default
  in_root do
    migration = Dir.glob("db/migrate/*").max_by{ |f| File.mtime(f) }
    gsub_file migration, /:admin/, ":admin, default: false"
  end

  run "rm db/migrate/*_devise_create_users.rb"
  copy_file "config/routes.rb", force: true
  copy_file "db/migrate/20221001000100_devise_create_users.rb", force: true

  # name_of_person gem
  append_to_file("app/models/user.rb", "has_person_name\n", after: "friendly_id :name, use: :slugged\n")
end

def copy_templates
  copy_file "Procfile.dev"
  copy_file "jsconfig.json"
  copy_file "tailwind.config.js"
  copy_file "postcss.config.js"
  copy_file "vite.config.ts"
  copy_file ".eslintrc.json"
  copy_file "config/vite.json"
  copy_file "package.json"
  copy_file "db/migrate/20221001000000_add_uuid_support.rb"

  directory "github", force: true
  directory "app", force: true
  directory "bin", force: true
  directory "config/initializers", force: true

  run "chmod +x bin/*"
  run "mv github .github"

  in_root do
    run "touch .env"
  end
end

def add_rspec
  generate "rspec:install"
end

def add_vite
  run 'bundle exec vite install'

  inject_into_file('vite.config.ts', "import FullReload from 'vite-plugin-full-reload'\n", after: %(from 'vite'\n))
  inject_into_file('vite.config.ts', "import StimulusHMR from 'vite-plugin-stimulus-hmr'\n", after: %(from 'vite'\n))
end

def add_javascript
  packages = %w[
    sass
    @hotwired/stimulus
    @hotwired/turbo-rails
    @shoelace-style/shoelace
    tailwindcss
    @turbo-boost/commands --exact
    @turbo-boost/streams --exact
    vite
  ]

  dev_packages = %w[
    @tailwindcss/forms
    @tailwindcss/typography
    @tailwindcss/aspect-ratio
    autoprefixer
    eslint
    eslint-config-prettier
    eslint-plugin-prettier
    eslint-plugin-tailwindcss
    path
    postcss
    prettier
    stimulus-vite-helpers
    tailwindcss
    typescript
    vite-plugin-rails
    vite-plugin-static-copy
  ]

  run "yarn add #{packages.join(' ')}"
  run "yarn add -D #{dev_packages.join(' ')}"

  run "npx tailwindcss init -p"
end

def add_sidekiq
  environment "config.active_job.queue_adapter = :sidekiq"
end

def add_friendly_id
  insert_into_file "app/models/user.rb", after: "class User < ApplicationRecord\n" do
    <<~RUBY
      extend FriendlyId

      friendly_id :name, use: :slugged
    RUBY
  end
end

def add_arel_helpers
  insert_into_file "app/models/application_record.rb", "  include ArelHelpers::ArelTable\n", after: "class ApplicationRecord < ActiveRecord::Base\n"
end

def add_bullet
  environment(nil, env: 'development') do
    <<~RUBY
      config.after_initialize do
        Bullet.enable = true
        # Bullet.sentry = true
        # Bullet.alert = true
        # Bullet.bullet_logger = true
        # Bullet.console = true
        # Bullet.xmpp = { :account  => 'bullets_account@jabber.org',
        #                 :password => 'bullets_password_for_jabber',
        #                 :receiver => 'your_account@jabber.org',
        #                 :show_online_status => true }
        Bullet.rails_logger = true
        # Bullet.honeybadger = true
        # Bullet.bugsnag = true
        # Bullet.appsignal = true
        # Bullet.airbrake = true
        # Bullet.rollbar = true
        # Bullet.add_footer = true
        # Bullet.skip_html_injection = false
        # Bullet.stacktrace_includes = [ 'your_gem', 'your_middleware' ]
        # Bullet.stacktrace_excludes = [ 'their_gem', 'their_middleware', ['my_file.rb', 'my_method'], ['my_file.rb', 16..20] ]
        # Bullet.slack = { webhook_url: 'http://some.slack.url', channel: '#default', username: 'notifier' }
      end

    RUBY
  end

  environment(nil, env: 'test') do
    <<~RUBY
      config.after_initialize do
        Bullet.enable        = true
        Bullet.bullet_logger = true
      end

    RUBY
  end
end

def run_cleanup
  run "bundle exec magic_frozen_string_literal"
  run "bundle exec standardrb --fix-unsafely"
end

def verbose(message, color: :yellow, &block)
  top_line = "┏======= #{message} #{"=" * 50}"
  say top_line, color
  yield
  say "┗#{'=' * (top_line.length - 1)}", color
end

# Main setup

source_paths

verbose("Set App Name") { set_application_name }
verbose("Add template to source path") { add_template_repository_to_source_path }
verbose("Adding Gems") { add_gems }

after_bundle do
  verbose("Copying Templates") { copy_templates }
  verbose("Adding RSpec") { add_rspec }
  verbose("Adding Javascript") { add_javascript }
  verbose("Adding Vite") { add_vite }
  verbose("Adding Arel Helpers") { add_arel_helpers }
  verbose("Adding Bullet") { add_bullet }
  verbose("Adding Devise and Users") { add_users }
  verbose("Adding Friendly ID") { add_friendly_id }
  verbose("Adding Sidekiq") { add_sidekiq }

  verbose("Running db:create db:migrate") do
    rails_command "db:drop"
    rails_command "db:create"
    rails_command "db:migrate"
  end

  verbose("Cleaning") do
    run_cleanup
  end

  say
  say "Rails app successfully created!"
  say
  say "Switch to your app by running:"
  say "$ cd #{app_name}", :yellow
  say
  say "Then run:"
  say "$ bin/dev", :green
end
