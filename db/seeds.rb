# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

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

puts "Seeding challenges..."
# Challenges by creators
ch1 = Challenge.create!(title: "Run 50km", description: "Complete 50km in 2 weeks", start_date: Date.today, end_date: Date.today + 14, creator: creator1)
ch2 = Challenge.create!(title: "500 Push-ups", description: "Do 500 push-ups in a month", start_date: Date.today, end_date: Date.today + 30, creator: creator1)
ch3 = Challenge.create!(title: "100 Squats", description: "Do 100 squats daily for a week", start_date: Date.today, end_date: Date.today + 7, creator: creator2)
ch4 = Challenge.create!(title: "Cycle 200km", description: "Cycle 200km in a month", start_date: Date.today, end_date: Date.today + 30, creator: creator2)

puts "Seeding participations..."
# Everyone joins some challenges
Participation.create!(user: participants[0], challenge: ch1, joined_at: DateTime.now, total_points: 0, status: "active")
Participation.create!(user: participants[1], challenge: ch1, joined_at: DateTime.now, total_points: 0, status: "active")
Participation.create!(user: participants[2], challenge: ch2, joined_at: DateTime.now, total_points: 0, status: "active")
Participation.create!(user: participants[3], challenge: ch3, joined_at: DateTime.now, total_points: 0, status: "active")
Participation.create!(user: participants[4], challenge: ch4, joined_at: DateTime.now, total_points: 0, status: "active")
Participation.create!(user: participants[5], challenge: ch2, joined_at: DateTime.now, total_points: 0, status: "active")
Participation.create!(user: participants[6], challenge: ch3, joined_at: DateTime.now, total_points: 0, status: "active")

puts "Seeding progress entries..."
# Some progress entries for participants
ProgressEntry.create!(participation: Participation.first, exercise: running, entry_date: Date.today, metric_value: 10, points: 100, notes: "Morning run")
ProgressEntry.create!(participation: Participation.second, exercise: running, entry_date: Date.today, metric_value: 5, points: 50, notes: "Evening run")
ProgressEntry.create!(participation: Participation.third, exercise: pushups, entry_date: Date.today, metric_value: 50, points: 50, notes: "Push-ups session")
ProgressEntry.create!(participation: Participation.fourth, exercise: squats, entry_date: Date.today, metric_value: 100, points: 100, notes: "Squats challenge")
ProgressEntry.create!(participation: Participation.fifth, exercise: cycling, entry_date: Date.today, metric_value: 30, points: 30, notes: "Cycling session")

puts "Seeding badges..."
# Badges
b1 = Badge.create!(name: "First Run", description: "Complete your first running session", condition: "total_distance >= 1 km")
b2 = Badge.create!(name: "Push-up Beginner", description: "Complete your first push-ups", condition: "total_reps >= 10")
b3 = Badge.create!(name: "Cyclist", description: "Cycle at least 50km", condition: "total_distance >= 50 km")
b4 = Badge.create!(name: "Squat Master", description: "Do 100 squats in a day", condition: "total_reps >= 100")

puts "Seeding user badges..."
# Award some badges
UserBadge.create!(user: participants[0], badge: b1, awarded_at: DateTime.now)
UserBadge.create!(user: participants[2], badge: b2, awarded_at: DateTime.now)
UserBadge.create!(user: participants[4], badge: b3, awarded_at: DateTime.now)
UserBadge.create!(user: participants[3], badge: b4, awarded_at: DateTime.now)

puts "Seeding finished!"

