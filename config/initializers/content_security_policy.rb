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
    policy.script_src  :self, :https, :unsafe_inline, :unsafe_hashes
    policy.style_src   :self, :https, :unsafe_inline, :unsafe_hashes

    # Allow development tools
    if Rails.env.development?
      policy.script_src :self, :https, :unsafe_eval, :unsafe_inline
      policy.connect_src :self, :https, "http://localhost:3035", "ws://localhost:3035"
    end
  end

  # Generate session nonces for permitted importmap, inline scripts, and inline styles.
  # Disable nonces in development to allow unsafe_inline
  unless Rails.env.development?
    config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
    config.content_security_policy_nonce_directives = %w[script-src style-src]
  end

  # Report violations without enforcing the policy in development
  config.content_security_policy_report_only = Rails.env.development?
end
