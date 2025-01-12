# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  # Reloading enabled for development.
  config.enable_reloading = true

  # Code is not eager-loaded in development.
  config.eager_load = false

  # Full error reports are shown.
  config.consider_all_requests_local = true

  # Enable server timing for debugging performance.
  config.server_timing = true

  # Caching configuration
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  # Mailer configuration
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  # Deprecation warnings
  config.active_support.deprecation = :log
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []

  # ActiveRecord configuration
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true

  # ActiveJob configuration
  config.active_job.verbose_enqueue_logs = true

  # ActionView configuration
  config.action_view.annotate_rendered_view_with_filenames = true

  # ActionController configuration
  config.action_controller.raise_on_missing_callback_actions = true
end
