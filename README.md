# Rails Template

An opinionated Rails 7+ application template.

### Included gems

- arel-helpers
- bullet
- devise
- friendly_id
- name_of_person
- sidekiq
- vite_rails
- whoop
- annotate
- magic_frozen_string_literal
- codecov
- model_probe
- organize_gemfile
- simplecov
- sord
- standard
- factory_bot_rails
- rspec-rails

## How it works

When creating a new rails app simply pass the template file through.

### Creating a new app

```bash
rails new sample_app --database=postgresql \
  --skip-spring \
  --skip-test \
  --skip-asset-pipeline \
  --skip-javascript \
  -m https://raw.githubusercontent.com/coderberry/rails-template/main/template.rb
```
