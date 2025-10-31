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

  # Create daily logs with time entries
  puts "\n⏱️  Creating daily logs..."

  created_deeds = admin.deeds.to_a

  # Create logs for the last 7 days
  7.downto(0) do |days_ago|
    date = days_ago.days.ago.to_date

    # Pick random deeds for this day (1-3 deeds per day)
    daily_deeds = created_deeds.sample(rand(1..3))

    daily_deeds.each do |deed|
      # Create 1-3 time entries per deed per day
      entries_count = rand(1..3)

      entries_count.times do |i|
        start_time = date.to_time + rand(8..17).hours + rand(0..59).minutes
        duration_minutes = rand(15..120) # 15 minutes to 2 hours
        end_time = start_time + duration_minutes.minutes

        admin.daily_logs.find_or_create_by!(
          deed_id: deed.id,
          start_time: start_time
        ) do |log|
          log.end_time = end_time
          log.updated_at = end_time
        end

        puts "     ⏰ #{date}: #{deed.title} - #{duration_minutes}min"
      end
    end
  end

  puts "✨ Seeding completed!"
  puts ""
  puts "Login credentials:"
  puts "  Email: admin@example.com"
  puts "  Password: password123"
end
