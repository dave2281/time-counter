# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self, :https
    policy.font_src    :self, :https, :data
    policy.img_src     :self, :https, :data
    policy.object_src  :none

    if Rails.env.development?
      # More permissive in development
      policy.script_src  :self, :https, :unsafe_eval, :unsafe_inline
      policy.style_src   :self, :https, :unsafe_inline
      policy.connect_src :self, :https, "http://localhost:3035", "ws://localhost:3035"
    else
      # Strict in production - no inline scripts/styles
      policy.script_src  :self, :https
      policy.style_src   :self, :https
    end
  end

  # Only use nonces in production
  if Rails.env.production? || Rails.env.staging?
    config.content_security_policy_nonce_generator = ->(request) { SecureRandom.base64(16) }
    config.content_security_policy_nonce_directives = %w[script-src style-src]
  end

  # Report violations without enforcing the policy in development
  config.content_security_policy_report_only = Rails.env.development?
end
