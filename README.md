# Rails Template

An opinionated Rails 7+ application template.

### Included gems

TBD

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
