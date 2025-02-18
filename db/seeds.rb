# Очищаем старые данные
User.destroy_all
Deed.destroy_all
DailyLog.destroy_all
Session.destroy_all

# Создаём пользователей
users = []
5.times do |i|
  users << User.create!(
    email_address: "user#{i + 1}@example.com",
    password_digest: BCrypt::Password.create('password123')
  )
end
puts "Создано пользователей: #{User.count}"

deeds = []
users.each do |user|
  3.times do |i|
    deeds << Deed.create!(
      user: user,
      title: "Дело ##{i + 1} для #{user.email_address}",
      description: "Описание для дела ##{i + 1}",
      total_time: nil
    )
  end
end
puts "Создано дел: #{Deed.count}"

deeds.each do |deed|
  4.times do
    start_time = Faker::Time.between(from: 5.years.ago, to: Time.zone.now)
    end_time = start_time + rand(1..4).hours + rand(0..59).minutes
    DailyLog.create!(
      deed: deed,
      user: deed.user,
      start_time: start_time,
      end_time: end_time
    )
  end
end
puts "Создано дневных логов: #{DailyLog.count}"

# Создаём сессии для пользователей
users.each do |user|
  Session.create!(
    user: user,
    ip_address: "192.168.1.#{rand(1..255)}",
    user_agent: "Mozilla/5.0 (compatible; Bot/#{rand(1..100)})"
  )
end
puts "Создано сессий: #{Session.count}"
