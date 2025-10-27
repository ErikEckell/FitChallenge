class HomeController < ApplicationController

  before_action :authenticate_user!, except: [:index, :leaderboard]

  def index
    @users_count = User.count
    @challenges_count = Challenge.count
    @participations_count = Participation.count
    @exercises_count = Exercise.count
    @badges_count = Badge.count

    @latest_challenges = Challenge.order(created_at: :desc).limit(5)
    @latest_progress_entries = ProgressEntry.includes(:participation, :exercise).order(entry_date: :desc).limit(5)
  end

    def leaderboard
    # === TOP 5 USERS POR TOTAL POINTS ===
    @top_points_users = User
      .left_joins(participations: :progress_entries)
      .select("users.*, COALESCE(SUM(progress_entries.points), 0) AS total_points_sum")
      .group("users.id")
      .order("total_points_sum DESC")
      .limit(5)

    # === TOP 5 USERS POR CHALLENGES COMPLETADOS ===
    @top_challenges_users = User
      .left_joins(:participations)
      .select("users.*, COUNT(CASE WHEN participations.status = 'completed' THEN 1 END) AS completed_challenges_sum")
      .group("users.id")
      .order("completed_challenges_sum DESC")
      .limit(5)

    # === TOP 5 USERS POR BADGES ===
    @top_badges_users = User
      .left_joins(:user_badges)
      .select("users.*, COUNT(user_badges.id) AS badges_count")
      .group("users.id")
      .order("badges_count DESC")
      .limit(5)

    # === TOP 5 USERS POR PROGRESS ENTRIES ===
    @top_entries_users = User
      .left_joins(participations: :progress_entries)
      .select("users.*, COUNT(progress_entries.id) AS entries_count")
      .group("users.id")
      .order("entries_count DESC")
      .limit(5)

    # === TOP 5 CREATORS POR CHALLENGES CREADOS ===
    @top_creators = User
      .where(role: "creator")
      .left_joins(:challenges)
      .select("users.*, COUNT(challenges.id) AS challenges_count")
      .group("users.id")
      .order("challenges_count DESC")
      .limit(5)
  end


end
