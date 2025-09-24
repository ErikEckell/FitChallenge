# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data (optional, for testing purposes)
UserBadge.destroy_all
Badge.destroy_all
UserStatistic.destroy_all
ProgressEntry.destroy_all
Participation.destroy_all
Exercise.destroy_all
Challenge.destroy_all
User.destroy_all

puts "Seeding users..."
# Users
alice = User.create!(name: "Alice", email: "alice@example.com", password: "123456", role: "participant")
bob   = User.create!(name: "Bob", email: "bob@example.com", password: "123456", role: "creator")
carol = User.create!(name: "Carol", email: "carol@example.com", password: "123456", role: "admin")


puts "Seeding challenges..."
# Challenges
running_challenge = Challenge.create!(title: "Run 100km", description: "Complete 100km in a month", start_date: Date.today, end_date: Date.today + 30, creator: bob)
pushup_challenge = Challenge.create!(title: "1000 Push-ups", description: "Do 1000 push-ups in a month", start_date: Date.today, end_date: Date.today + 30, creator: bob)

puts "Seeding participations..."
# Participations
alice_running = Participation.create!(user: alice, challenge: running_challenge, joined_at: DateTime.now, total_points: 0, status: "active")
alice_pushups = Participation.create!(user: alice, challenge: pushup_challenge, joined_at: DateTime.now, total_points: 0, status: "active")

puts "Seeding exercises..."
# Exercises
running = Exercise.create!(name: "Running", category: "Cardio", unit: "km")
pushups = Exercise.create!(name: "Push-ups", category: "Strength", unit: "reps")

puts "Seeding progress entries..."
# Progress Entries
ProgressEntry.create!(participation: alice_running, exercise: running, entry_date: Date.today, metric_value: 5.0, points: 50, notes: "Morning run")
ProgressEntry.create!(participation: alice_pushups, exercise: pushups, entry_date: Date.today, metric_value: 50, points: 50, notes: "Evening push-ups")

puts "Seeding user statistics..."
# User Statistics
UserStatistic.create!(user: alice, total_points: 100, total_distance: 5.0, total_reps: 50, total_minutes: 0, completed_challenges: 0, last_update: DateTime.now)

puts "Seeding badges..."
# Badges
Badge.create!(name: "First Run", description: "Complete your first running session", condition: "total_distance >= 1 km")
Badge.create!(name: "Push-up Beginner", description: "Complete your first push-ups", condition: "total_reps >= 10")

puts "Seeding user badges..."
# User Badges
UserBadge.create!(user: alice, badge: Badge.first, awarded_at: DateTime.now)

puts "Seeding finished!"
