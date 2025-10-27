# db/seeds.rb
require 'faker'

puts "🧹 Clearing existing data..."
UserBadge.destroy_all
Badge.destroy_all
UserStatistic.destroy_all
ProgressEntry.destroy_all
Participation.destroy_all
Exercise.destroy_all
Challenge.destroy_all
User.destroy_all

puts "👥 Seeding users..."
# Users: 1 admin, 2 creators, 7 participants
admin = User.create!(name: "Carol Admin", email: "carol@example.com", password: "123456", role: "admin")
creator1 = User.create!(name: "Bob Creator", email: "bob@example.com", password: "123456", role: "creator")
creator2 = User.create!(name: "Eve Creator", email: "eve@example.com", password: "123456", role: "creator")

participants = []
7.times do |i|
  participants << User.create!(
    name: Faker::Name.first_name,
    email: "participant#{i+1}@example.com",
    password: "123456",
    role: "participant"
  )
end

puts "🏋️ Seeding exercises..."
running = Exercise.create!(name: "Running", category: "Cardio", unit: "km")
pushups = Exercise.create!(name: "Push-ups", category: "Strength", unit: "reps")
squats = Exercise.create!(name: "Squats", category: "Strength", unit: "reps")
cycling = Exercise.create!(name: "Cycling", category: "Cardio", unit: "km")
plank = Exercise.create!(name: "Plank", category: "Core", unit: "minutes")
exercises = [running, pushups, squats, cycling, plank]

puts "🏆 Seeding challenges..."
ch1 = Challenge.create!(title: "Run 50km", description: "Complete 50km in 2 weeks", start_date: Date.today - 10, end_date: Date.today + 10, creator: creator1)
ch2 = Challenge.create!(title: "500 Push-ups", description: "Do 500 push-ups in a month", start_date: Date.today - 15, end_date: Date.today + 15, creator: creator1)
ch3 = Challenge.create!(title: "100 Squats Daily", description: "Do 100 squats daily for a week", start_date: Date.today - 5, end_date: Date.today + 5, creator: creator2)
ch4 = Challenge.create!(title: "Cycle 200km", description: "Cycle 200km in a month", start_date: Date.today - 8, end_date: Date.today + 22, creator: creator2)
ch5 = Challenge.create!(title: "Plank Challenge", description: "Hold plank 5 min daily", start_date: Date.today - 3, end_date: Date.today + 12, creator: creator2)

puts "📈 Seeding participations and progress entries..."
# Assign participations
participants.each do |p|
  [ch1, ch2, ch3].each do |ch|
    # Some participants will have completed challenges
    status = rand < 0.3 ? "completed" : "active"
    part = Participation.create!(user: p, challenge: ch, joined_at: ch.start_date, total_points: 0, status: status)

    # Create 3 progress entries per participation
    3.times do |i|
      exercise = case ch
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

      # Ensure entry_date is within challenge dates
      entry_date = ch.start_date + rand(0..(ch.end_date - ch.start_date))
      ProgressEntry.create!(
        participation: part,
        exercise: exercise,
        entry_date: entry_date,
        metric_value: metric_value,
        points: points,
        notes: "Entry #{i + 1}"
      )

      # Update total_points in participation
      part.update!(total_points: part.progress_entries.sum(:points))
    end
  end
end

# Additional participations for ch4 and ch5
participants[0..3].each do |p|
  part = Participation.create!(user: p, challenge: ch4, joined_at: ch4.start_date, total_points: 0, status: "active")
end
participants[2..5].each do |p|
  part = Participation.create!(user: p, challenge: ch5, joined_at: ch5.start_date, total_points: 0, status: "active")
end

puts "🏅 Seeding badges..."
b1 = Badge.create!(name: "First Run", description: "Complete your first running session", condition: "total_distance >= 1 km")
b2 = Badge.create!(name: "Push-up Beginner", description: "Complete your first push-ups", condition: "total_reps >= 10")
b3 = Badge.create!(name: "Cyclist", description: "Cycle at least 50km", condition: "total_distance >= 50 km")
b4 = Badge.create!(name: "Squat Master", description: "Do 100 squats in a day", condition: "total_reps >= 100")
b5 = Badge.create!(name: "Plank Pro", description: "Hold plank for 5 minutes", condition: "total_minutes >= 5")

participants.each_with_index do |p, i|
  UserBadge.create!(user: p, badge: b1, awarded_at: DateTime.now) if i.even?
  UserBadge.create!(user: p, badge: b2, awarded_at: DateTime.now) if i.odd?
end

puts "✅ Seeding finished!"
puts "Admin user: #{admin.email} / 123456"
participants.each { |p| puts "Participant user: #{p.email} / 123456" }
puts "Creators: #{creator1.email}, #{creator2.email} / 123456"
