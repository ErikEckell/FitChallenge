class ProgressEntriesController < ApplicationController
  before_action :set_progress_entry, only: [:show, :edit, :update, :destroy]

  def index
    @progress_entries = ProgressEntry.all
  end

  def show
  end

  def new
    @participation = Participation.find(params[:participation_id])
    @progress_entry = ProgressEntry.new
  end

  def create
    @progress_entry = ProgressEntry.new(progress_entry_params)
    if @progress_entry.save
      check_and_award_badges(@progress_entry.participation.user)
      redirect_to @progress_entry.participation.challenge, notice: "Progress submitted!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @progress_entry.update(progress_entry_params)
      redirect_to @progress_entry, notice: "Progress entry successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @progress_entry.destroy
    redirect_to progress_entries_path, notice: "Progress entry successfully deleted."
  end

  private

  def set_progress_entry
    @progress_entry = ProgressEntry.find(params[:id])
  end

  def progress_entry_params
    params.require(:progress_entry).permit(:participation_id, :exercise_id, :entry_date, :metric_value, :points, :notes)
  end

  # Método para otorgar badges automáticamente
  def check_and_award_badges(user)
    Badge.all.each do |badge|
      next if user.badges.include?(badge)
      # Evaluar condición usando eval (puedes usar un método más seguro según convenga)
      if eval(badge.condition.gsub("user.", "user.")) # adaptado para que el condition sea Ruby
        UserBadge.create!(user: user, badge: badge, awarded_at: DateTime.now)
      end
    end
  end

end
