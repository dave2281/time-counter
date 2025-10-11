# This file should remain empty for production.
# Use rails console or admin interface to create users.

# For development only:
if Rails.env.development?
  puts "Development seed data can be added here if needed"
  puts "Current users count: #{User.count}"
  puts "Current deeds count: #{Deed.count}"
end
