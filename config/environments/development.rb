require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Make code changes take effect immediately without server restart.
  config.enable_reloading = true

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable server timing.
  config.server_timing = true

  # Enable/disable Action Controller caching.
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true
    config.public_file_server.headers = {
      "cache-control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false
  end

  # Change to :null_store to avoid any caching.
  config.cache_store = :memory_store

  # Store uploaded files locally.
  config.active_storage.service = :local

  # Actually send emails
  config.action_mailer.perform_deliveries = true

  # Use SMTP instead of Letter Opener
  config.action_mailer.delivery_method = :smtp

  # Raise errors if email delivery fails
  config.action_mailer.raise_delivery_errors = true

  # Make template changes take effect immediately.
  config.action_mailer.perform_caching = false

  # SMTP settings (Gmail example)
  config.action_mailer.smtp_settings = {
    address: ENV["SMTP_ADDRESS"],        # smtp.gmail.com
    port: ENV["SMTP_PORT"],              # 587
    domain: ENV["SMTP_DOMAIN"],          # localhost or your domain
    user_name: ENV["SMTP_USERNAME"],     # your email
    password: ENV["SMTP_PASSWORD"],      # app password
    authentication: "plain",
    enable_starttls_auto: true
  }

  #  Used by mailer links (email verification URLs)
  config.action_mailer.default_url_options = {
    host: "noninfusible-preconsonantal-will.ngrok-free.dev",
    protocol: "https"
  }

  #  Required for url_for, ActiveStorage, mentions, etc.
  Rails.application.routes.default_url_options[:host] =
    "noninfusible-preconsonantal-will.ngrok-free.dev"

  #  Allow ngrok host (prevents "Blocked host" error on iOS)
  config.hosts << "noninfusible-preconsonantal-will.ngrok-free.dev"

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Append comments with runtime info to SQL queries.
  config.active_record.query_log_tags_enabled = true

  # Highlight background job enqueue logs.
  config.active_job.verbose_enqueue_logs = true

  # Highlight redirect logs.
  config.action_dispatch.verbose_redirect_logs = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Annotate rendered views with filenames.
  config.action_view.annotate_rendered_view_with_filenames = true

  # Raise error when before_action references missing actions.
  config.action_controller.raise_on_missing_callback_actions = true
end
