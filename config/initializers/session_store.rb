# Configure session security settings
Rails.application.configure do
  # Session configuration for security
  config.session_store :cookie_store,
    key: "_time_tracker_session",
    secure: Rails.env.production?,
    httponly: true,
    same_site: :lax,
    expire_after: 2.weeks
end
