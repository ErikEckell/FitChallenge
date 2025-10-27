class ProgressEntriesController < ApplicationController
  before_action :set_progress_entry, only: [:show, :edit, :update, :destroy]

  def index
    @progress_entries = ProgressEntry.all
  end

  def show
  end

  def new
    if params[:participation_id].present?
      @participation = Participation.find(params[:participation_id])
      @progress_entry = ProgressEntry.new
    else
      redirect_to participations_path, alert: "No participation specified for this entry."
    end
  end

  def create
    @participation = Participation.find(params[:participation_id])
    @progress_entry = @participation.progress_entries.build(progress_entry_params)

    if @progress_entry.save
      redirect_to @participation.challenge, notice: "Progress entry created successfully!"
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
