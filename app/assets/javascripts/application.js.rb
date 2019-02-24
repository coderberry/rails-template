gsub_file "app/assets/javascripts/application.js", /^.*require rails-ujs$/ do
  <<~JAVASCRIPT.strip
    //= require activestorage
    //= require turbolinks
    //= require_tree .
  JAVASCRIPT
end
