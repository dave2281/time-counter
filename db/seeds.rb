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

User.create!(email_address: "admin@gmail.com",
             password_digest: BCrypt::Password.create('password123')
)

deeds = []
users.each do |user|
  3.times do |i|
    deeds << Deed.create!(
      user: user,
      title: "Дело ##{i + 1} для #{user.email_address}",
      description: "Описание для дела ##{i + 1}",
      finished: [true, false].sample,
      total_time: nil
    )
  end
end
puts "Создано дел: #{Deed.count}"

deeds.each do |deed|
  4.times do
    start_time = Faker::Time.between(from: 5.years.ago, to: Time.zone.now)
    end_time = start_time + rand(10..50).hours + rand(0..59).minutes + rand(0.59).seconds
    DailyLog.create!(
      deed: deed,
      user: deed.user,
      start_time: start_time,
      end_time: end_time
    )
  end
end
puts "Создано дневных логов: #{DailyLog.count}"
