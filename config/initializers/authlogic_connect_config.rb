# Config to load OAuth credentials

case Rails.env
when "development"
  AuthlogicConnect.config = YAML.load_file("config/authlogic.yml")
when "production"
  # Presume this will be different in the end!
  AuthlogicConnect.config = YAML.load_file("config/authlogic.yml")
end
