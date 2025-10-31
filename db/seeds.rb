if Rails.env.development?
  puts "🌱 Seeding development data..."

  admin = User.find_or_create_by!(email_address: "admin@example.com") do |user|
    user.password = "password123"
    user.password_confirmation = "password123"
    user.roles = "admin"
    user.confirmed_at = Time.current
  end

  puts "✅ Admin user created: #{admin.email_address}"
  puts "   Password: password123"

  deeds_data = [
    {
      title: "Build Time Tracker App",
      description: "Complete Ruby on Rails time tracking application with premium features",
      color: "#3B82F6",
      finished: false,
      total_time: "2h20m12s"
    },
    {
      title: "Code Review",
      description: "Review pull requests and provide feedback to team members",
      color: "#10B981",
      finished: false,
      total_time: "2h20m12s"
    },
    {
      title: "Write Documentation",
      description: "Update README and API documentation for the project",
      color: "#F59E0B",
      finished: true,
      total_time: "2h20m12s"
    },
    {
      title: "Team Meeting",
      description: "Daily standup and sprint planning session",
      color: "#8B5CF6",
      finished: true,
      total_time: "2h20m12s"
    }
  ]

  deeds_data.each do |deed_attrs|
    deed = admin.deeds.find_or_create_by!(title: deed_attrs[:title]) do |d|
      d.description = deed_attrs[:description]
      d.color = deed_attrs[:color]
      d.finished = deed_attrs[:finished]
      d.total_time = deed_attrs[:total_time]
    end
    puts "   📋 Created deed: #{deed.title}"
  end

  puts "✨ Seeding completed!"
  puts ""
  puts "Login credentials:"
  puts "  Email: admin@example.com"
  puts "  Password: password123"
end
