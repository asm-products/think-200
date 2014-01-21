Think200::Application.configure do  
  config.action_mailer.default_options     = {from: ENV['SENDER_EMAIL']}
  config.action_mailer.default_url_options = { :host => ENV["DOMAIN"] }
  config.action_mailer.delivery_method     = :smtp
  config.action_mailer.smtp_settings = {
    address:              ENV["SMTP_SERVER"],
    openssl_verify_mode:  OpenSSL::SSL::VERIFY_NONE,
    port:                 ENV["SMTP_PORT"],
    domain:               ENV["MAILER_DOMAIN"],
    authentication:       "plain",
    enable_starttls_auto: true,
    user_name:            ENV["SMTP_USER"],
    password:             ENV["SMTP_PWD"]
  }
end
