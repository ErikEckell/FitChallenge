# Clear existing data
UserBadge.destroy_all
Badge.destroy_all
UserStatistic.destroy_all
ProgressEntry.destroy_all
Participation.destroy_all
Exercise.destroy_all
Challenge.destroy_all
User.destroy_all

puts "Seeding users..."
# Users: 1 admin, 2 creators, 7 participants
admin = User.create!(name: "Carol Admin", email: "carol@example.com", password: "123456", role: "admin")
creator1 = User.create!(name: "Bob Creator", email: "bob@example.com", password: "123456", role: "creator")
creator2 = User.create!(name: "Eve Creator", email: "eve@example.com", password: "123456", role: "creator")

participants = []
participants << User.create!(name: "Alice", email: "alice@example.com", password: "123456", role: "participant")
participants << User.create!(name: "Dave", email: "dave@example.com", password: "123456", role: "participant")
participants << User.create!(name: "Frank", email: "frank@example.com", password: "123456", role: "participant")
participants << User.create!(name: "Grace", email: "grace@example.com", password: "123456", role: "participant")
participants << User.create!(name: "Heidi", email: "heidi@example.com", password: "123456", role: "participant")
participants << User.create!(name: "Ivan", email: "ivan@example.com", password: "123456", role: "participant")
participants << User.create!(name: "Judy", email: "judy@example.com", password: "123456", role: "participant")

puts "Seeding exercises..."
# Exercises
running = Exercise.create!(name: "Running", category: "Cardio", unit: "km")
pushups = Exercise.create!(name: "Push-ups", category: "Strength", unit: "reps")
squats = Exercise.create!(name: "Squats", category: "Strength", unit: "reps")
cycling = Exercise.create!(name: "Cycling", category: "Cardio", unit: "km")
plank = Exercise.create!(name: "Plank", category: "Core", unit: "minutes")

puts "Seeding challenges..."
# Challenges by creators
ch1 = Challenge.create!(title: "Run 50km", description: "Complete 50km in 2 weeks", start_date: Date.today - 3, end_date: Date.today + 11, creator: creator1)
ch2 = Challenge.create!(title: "500 Push-ups", description: "Do 500 push-ups in a month", start_date: Date.today - 7, end_date: Date.today + 23, creator: creator1)
ch3 = Challenge.create!(title: "100 Squats Daily", description: "Do 100 squats daily for a week", start_date: Date.today - 1, end_date: Date.today + 6, creator: creator2)
ch4 = Challenge.create!(title: "Cycle 200km", description: "Cycle 200km in a month", start_date: Date.today, end_date: Date.today + 30, creator: creator2)
ch5 = Challenge.create!(title: "Plank Challenge", description: "Hold plank 5 min daily", start_date: Date.today - 2, end_date: Date.today + 12, creator: creator2)

puts "Seeding participations..."
# Everyone joins multiple challenges
participants.each do |p|
  Participation.create!(user: p, challenge: ch1, joined_at: DateTime.now, total_points: 0, status: "active")
  Participation.create!(user: p, challenge: ch2, joined_at: DateTime.now, total_points: 0, status: "active")
  Participation.create!(user: p, challenge: ch3, joined_at: DateTime.now, total_points: 0, status: "active")
end

# Add a few participants to ch4 and ch5
participants[0..3].each { |p| Participation.create!(user: p, challenge: ch4, joined_at: DateTime.now, total_points: 0, status: "active") }
participants[2..5].each { |p| Participation.create!(user: p, challenge: ch5, joined_at: DateTime.now, total_points: 0, status: "active") }

puts "Seeding progress entries..."
# Generate multiple progress entries per participant per challenge
Participation.all.each do |part|
  3.times do |i|
    exercise = case part.challenge
               when ch1 then running
               when ch2 then pushups
               when ch3 then squats
               when ch4 then cycling
               when ch5 then plank
               end

    metric_value = case exercise
                   when running, cycling then rand(3..10)
                   when pushups, squats then rand(20..100)
                   when plank then rand(1..5)
                   end

    points = metric_value * 10
    ProgressEntry.create!(participation: part, exercise: exercise, entry_date: Date.today - i, metric_value: metric_value, points: points, notes: "Entry #{i + 1}")
  end
end

puts "Seeding badges..."
# Badges
b1 = Badge.create!(name: "First Run", description: "Complete your first running session", condition: "total_distance >= 1 km")
b2 = Badge.create!(name: "Push-up Beginner", description: "Complete your first push-ups", condition: "total_reps >= 10")
b3 = Badge.create!(name: "Cyclist", description: "Cycle at least 50km", condition: "total_distance >= 50 km")
b4 = Badge.create!(name: "Squat Master", description: "Do 100 squats in a day", condition: "total_reps >= 100")
b5 = Badge.create!(name: "Plank Pro", description: "Hold plank for 5 minutes", condition: "total_minutes >= 5")

puts "Seeding user badges..."
# Award some badges to participants
participants.each_with_index do |p, i|
  UserBadge.create!(user: p, badge: b1, awarded_at: DateTime.now) if i.even?
  UserBadge.create!(user: p, badge: b2, awarded_at: DateTime.now) if i.odd?
  UserBadge.create!(user: p, badge: b3, awarded_at: DateTime.now) if i < 4
  UserBadge.create!(user: p, badge: b4, awarded_at: DateTime.now) if i >= 4
  UserBadge.create!(user: p, badge: b5, awarded_at: DateTime.now) if i % 3 == 0
end

puts "Seeding finished!"
