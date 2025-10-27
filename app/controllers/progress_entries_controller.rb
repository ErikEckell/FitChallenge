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
      redirect_to progress_entries_path, notice: "Progress entry created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @progress_entry.update(progress_entry_params)
      redirect_to progress_entries_path, notice: "Progress entry updated successfully."
    else
      render :edit, status: :unprocessable_entity
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
end
