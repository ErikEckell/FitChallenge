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
end
