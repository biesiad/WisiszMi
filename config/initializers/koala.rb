# config/initializers/koala.rb
module Facebook
  APP_ID = ENV['app_id'] || YAML.load_file(Rails.root.join("config/koala.yml"))[Rails.env]['app_id']
  APP_SECRET = ENV['app_secret'] || YAML.load_file(Rails.root.join("config/koala.yml"))[Rails.env]['app_secret']
end
