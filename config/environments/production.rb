Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.serve_static_files = ENV["RAILS_SERVE_STATIC_FILES"].present?
  config.assets.js_compressor = :uglifier
  config.assets.compile = false
  config.assets.digest = true
  config.log_level = :debug

  config.action_mailer.default_url_options = { host:
    Rails.application.secrets.host }

  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  config.active_record.dump_schema_after_migration = false

  Rails.application.config.action_mailer.delivery_method = :postmark
  Rails.application.config.action_mailer.postmark_settings = { api_token:
    Rails.application.secrets.postmark_api_token }
end