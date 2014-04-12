Think200::Application.configure do
  Dotenv.overload('.env.local')
  # config.action_mailer.preview_path = "#{Rails.root}/lib/mailer_previews"

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  
  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Mailer
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { :host => ENV['DEV_MAILER_URL'] }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:   'smtp.mandrillapp.com',
    port:      587,
    user_name: 'robb@weblaws.org',
    password:  'Nhb1wo6JFM_5ryNspJbZYA',
  }


  BetterErrors::Middleware.allow_ip! ENV['TRUSTED_IP'] if ENV['TRUSTED_IP']
end
