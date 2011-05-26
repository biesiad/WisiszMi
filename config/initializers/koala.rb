# config/initializers/koala.rb
module Facebook
  CONFIG = YAML.load_file(Rails.root.join("config/koala.yml"))[Rails.env]
  APP_ID = CONFIG['app_id']
  APP_SECRET = CONFIG['app_secret']
end
