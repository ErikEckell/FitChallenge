class ProgressEntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_progress_entry, only: %i[show edit update destroy]
  before_action :authorize_access!, only: %i[destroy]

  def index
    if current_user.admin?
      @progress_entries = ProgressEntry.includes(:exercise, participation: :challenge)
    elsif current_user.creator?
      # Creador: ve todas las entries de sus challenges
      @progress_entries = ProgressEntry
        .joins(participation: :challenge)
        .where(challenges: { creator_id: current_user.id })
        .includes(:exercise, participation: :challenge)
    else
      # Participante: ve solo las suyas
      @progress_entries = ProgressEntry
        .joins(:participation)
        .where(participations: { user_id: current_user.id })
        .includes(:exercise, participation: :challenge)
    end
  end

  def show
    @progress_entry = ProgressEntry.find(params[:id])
  end
  
  def new
    @progress_entry = ProgressEntry.new
  end

  def create
    @progress_entry = ProgressEntry.new(progress_entry_params)
if @progress_entry.save
  user = @progress_entry.participation.user
  user.update_statistics!       # recalcula estadísticas
  user.check_and_award_badges   # verifica si puede ganar badges
  redirect_to @progress_entry, notice: "Progress entry created!"
else
  render :new
end

  end



  def edit; end

  def update
    @progress_entry = ProgressEntry.new(progress_entry_params)
    if @progress_entry.save
  user = @progress_entry.participation.user
  user.update_statistics!       # recalcula estadísticas
  user.check_and_award_badges   # verifica si puede ganar badges
  redirect_to @progress_entry, notice: "Progress entry created!"
else
  render :new
end

  end


  def destroy
    @progress_entry.destroy
    redirect_to progress_entries_path, notice: "Progress entry deleted successfully."
  end

  private

  def set_progress_entry
    @progress_entry = ProgressEntry.find(params[:id])
  end

  def progress_entry_params
    params.require(:progress_entry).permit(:participation_id, :exercise_id, :entry_date, :metric_value)
  end

  def authorize_access!
    return if current_user.admin?

    challenge = @progress_entry.participation.challenge
    unless current_user == challenge.creator || current_user == @progress_entry.participation.user
      redirect_to progress_entries_path, alert: "You are not authorized to delete this entry."
    end
  end

  def update_related_points(entry)
  participation = entry.participation
  user = participation.user

  # 🔹 1. Recalcular puntos totales de la participación
  participation.update(total_points: participation.progress_entries.sum(:points))

  # 🔹 2. Recalcular estadísticas del usuario
  stats = user.user_statistic || user.create_user_statistic
  stats.update(
    total_points: user.participations.sum(:total_points),
    total_distance: user.participations.joins(progress_entries: :exercise).where("exercises.unit = ?", "km").sum("progress_entries.metric_value"),
    total_reps: user.participations.joins(progress_entries: :exercise).where("exercises.unit = ?", "reps").sum("progress_entries.metric_value"),
    total_minutes: user.participations.joins(progress_entries: :exercise).where("exercises.unit = ?", "minutes").sum("progress_entries.metric_value"),
    completed_challenges: user.participations.where(status: "completed").count,
    last_update: Time.current
  )
end
end
