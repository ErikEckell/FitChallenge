class HomeController < ApplicationController
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
    # Top 5 usuarios con más puntos (0 si no tienen user_statistic)
    @top_points_users = User.left_joins(:user_statistic)
                            .select("users.*, COALESCE(user_statistics.total_points, 0) AS total_points_sum")
                            .order("total_points_sum DESC")
                            .limit(5)

    # Top 5 usuarios con más challenges completados (0 si no tienen user_statistic)
    @top_challenges_users = User.left_joins(:user_statistic)
                                .select("users.*, COALESCE(user_statistics.completed_challenges, 0) AS completed_challenges_sum")
                                .order("completed_challenges_sum DESC")
                                .limit(5)

    # Top 5 usuarios con más badges
    @top_badges_users = User.left_joins(:user_badges)
                            .group("users.id")
                            .select("users.*, COUNT(user_badges.id) AS badges_count")
                            .order("badges_count DESC")
                            .limit(5)

    # Top 5 usuarios con más progress entries
    @top_entries_users = User.left_joins(participations: :progress_entries)
                             .group("users.id")
                             .select("users.*, COUNT(progress_entries.id) AS entries_count")
                             .order("entries_count DESC")
                             .limit(5)

    # Top 5 creadores con más challenges creados
    @top_creators = User.left_joins(:challenges)
                        .group("users.id")
                        .select("users.*, COUNT(challenges.id) AS challenges_count")
                        .order("challenges_count DESC")
                        .limit(5)
  end

end
